#include "ruby.h"
#include <math.h>
#include <stdlib.h>

#ifndef TRUE
#define TRUE 1
#define FALSE 0
#endif


// Validate the incoming array
static int validate( VALUE self ) {
    long length;
    VALUE *values = RARRAY_PTR( self );

    // Check we're an Array
    Check_Type( self, T_ARRAY );

    // make sure we have an array of two arrays
    if( RARRAY_LEN( self ) != 2 ) return FALSE;

    // make sure the arrays are of the same length
    if( RARRAY_LEN( values[0] ) != RARRAY_LEN( values[1] ) ) return FALSE;

    // make sure the size of the array is a power of 2
    length = RARRAY_LEN( values[0] );
    if( ( length < 2 ) || ( length & ( length - 1 ) ) ) return FALSE;

    return TRUE;
}

static VALUE perform_fft( double **values, long length, int direction )
{
    VALUE outArray = rb_ary_new2( 2 );
    VALUE xArray = rb_ary_new2( length );
    VALUE yArray = rb_ary_new2( length );

    unsigned int position, target, mask, jump;
    unsigned int step, group, pair, i;
    double multiplier_real, multiplier_imag, factor_real, factor_imag, product_real, product_imag;
    double temp_real, temp_imag, delta, sine, pi = direction * (-3.14159265358979323846);
    double old_factor_real;

    // do the bit reversal
    target = 0;
    for( position = 0; position < length; ++position )
    {
        if( target > position )
        {
            temp_real = values[0][position];
            temp_imag = values[1][position];
            values[0][position] = values[0][target];
            values[1][position] = values[1][target];
            values[0][target] = temp_real;
            values[1][target] = temp_imag;
        }
        mask = length;
        while( target & (mask >>= 1))
            target &= ~mask;
        target |= mask;
    }

    // compute the FFT
    for( step = 1; step < length; step <<= 1 )
    {
        // jump to the next entry of the same transform factor
        jump = step << 1;
        // angle increment
        delta = pi / (double) step;
        // auxiliary sin(delta / 2)
        sine = sin(delta * 0.5);
        // multiplier for trigonometric recurrence
        multiplier_real = -2.0 * sine * sine;
        multiplier_imag = sin(delta);
        // start value for transform factor, fi = 0
        factor_real = 1.0;
        factor_imag = 0.0;
        // iteration through groups of different transform factor
        for( group = 0; group < step; ++group )
        {
            // iteration within group
            for( pair = group; pair < length; pair += jump )
            {
                position = pair + step;
                // second term of two-point transform
                product_real = factor_real * values[0][position] - factor_imag * values[1][position];
                product_imag = factor_imag * values[0][position] + factor_real * values[1][position];
                // transform for fi + pi
                values[0][position] = values[0][pair] - product_real;
                values[1][position] = values[1][pair] - product_imag;
                // transform for fi
                values[0][pair] += product_real;
                values[1][pair] += product_imag;
            }
            // successive transform factor via trigonometric recurrence
            old_factor_real = factor_real;
            factor_real = multiplier_real * factor_real - multiplier_imag * factor_imag + factor_real;
            factor_imag = multiplier_imag * old_factor_real + multiplier_real * factor_imag + factor_imag;
        }
    }

    // scaling for inverse transform
    if( direction == -1 )
    {
        for( i = 0; i < length; i++ )
        {
            values[0][i] /= length;
            values[1][i] /= length;
        }
    }

    // convert the doubles into ruby numbers and stick them into a ruby array
    for( i = 0; i < length; i++ )
    {
        rb_ary_push( xArray, DBL2NUM( values[0][i] ) );
        rb_ary_push( yArray, DBL2NUM( values[1][i] ) );
    }

    rb_ary_push( outArray, xArray );
    rb_ary_push( outArray, yArray );

    return outArray;
}

// perform the fft
static VALUE prepare_fft( VALUE inArray, int direction ){
    long i, length;
    VALUE *values;
    double **transformed;
    VALUE outArray;

    if( !validate( inArray ) ) {
        return Qnil;
    }

    // convert the ruby array into a C array of integers using NUM2DBL(Fixnum)
    values = RARRAY_PTR( inArray );
    length = RARRAY_LEN( values[0] );
    transformed = malloc( sizeof( double ) * 2 );
    transformed[0] = malloc( sizeof( double* ) * RARRAY_LEN( values[0] ) );
    transformed[1] = malloc( sizeof( double* ) * RARRAY_LEN( values[1] ) );
    for( i = 0; i < length; i++ ) {
        // process values
        transformed[0][i] = NUM2DBL( RARRAY_PTR( values[0] )[i] );
        transformed[1][i] = NUM2DBL( RARRAY_PTR( values[1] )[i] );
    }

    // do the actual transform
    outArray = perform_fft( transformed, length, direction );

    // No memory leaks here!
    free( transformed[0] );
    free( transformed[1] );
    free( transformed );

    return outArray;
}

static VALUE forward_fft( VALUE self ){
    return prepare_fft( self, 1 );
}

static VALUE reverse_fft( VALUE self ){
    return prepare_fft( self, -1 );
}

// initalizer
VALUE FFT;
void Init_fft_api() {
    FFT = rb_define_module("FFTAPI");
    rb_define_method(FFT, "fft", forward_fft, 0);
    rb_define_method(FFT, "rfft", reverse_fft, 0);
}
