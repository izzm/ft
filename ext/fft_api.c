/**
 * @file fft_api.c
 * @brief The C API for processing a Fast Fourier Transform (FFT) for Ruby.
 * Forked from https://github.com/slowjud/FFT
 * @author jude.sutton@gmail.com, placek@ragnarson.com
 * @date 10.05.2012
 */
#include "ruby.h"
#include <math.h>
#include <stdlib.h>

/**
 * @brief This function validates the incoming array.
 * The array of data should contain two arrays: the first one with real parts
 * and the second one with imaginary parts of processing data.
 * The function validates the length of incoming data, the length of inner arrays
 * and reasures that the length is a power of 2.
 * @author jude.sutton@gmail.com
 * @param self An array we work on.
 * @return A validation result (1 if passed, 0 if failed).
 */
static int validate(VALUE self)
{
    long length;
    VALUE * values = RARRAY_PTR( self );

    // check if instance of Array
    Check_Type(self, T_ARRAY);

    // make sure we have an array of two arrays
    if(RARRAY_LEN(self) != 2) return 0;

    // make sure the arrays are of the same length
    if(RARRAY_LEN( values[0]) != RARRAY_LEN(values[1])) return 0;

    // make sure the size of the array is a power of 2
    length = RARRAY_LEN(values[0]);
    if((length < 2) || (length & (length - 1))) return 0;

    return 1;
}

/**
 * @brief Compute a FTT.
 * This function computes the FFT and returns the Ruby Array with the same size
 * and structure as input.
 * @see validate()
 * @author placek@ragnarson.com
 * @param values An array of processing data.
 * @params length Length of processing data.
 * @params direction An FFT direction (1 - forward FFT, -1 - reverse FFT).
 * @return An Ruby Array with FFT processed data.
 */
static VALUE perform_fft(double ** values, long length, int direction)
{
    VALUE outArray = rb_ary_new2(2);
    VALUE xArray = rb_ary_new2(length);
    VALUE yArray = rb_ary_new2(length);

    unsigned int position, target, mask, jump;
    unsigned int step, group, pair, i;
    double multiplier_real, multiplier_imag, factor_real, factor_imag, product_real, product_imag;
    double temp_real, temp_imag, delta, sine, pi = direction * (-3.14159265358979323846);
    double old_factor_real;

    // do the bit reversal
    target = 0;
    for(position = 0; position < length; ++position)
    {
        if(target > position)
        {
            temp_real = values[0][position];
            temp_imag = values[1][position];
            values[0][position] = values[0][target];
            values[1][position] = values[1][target];
            values[0][target] = temp_real;
            values[1][target] = temp_imag;
        }
        mask = length;
        while(target & (mask >>= 1))
            target &= ~mask;
        target |= mask;
    }

    // compute the FFT
    for(step = 1; step < length; step <<= 1)
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
        for(group = 0; group < step; ++group)
        {
            // iteration within group
            for(pair = group; pair < length; pair += jump)
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
    if(direction == -1)
    {
        for(i = 0; i < length; i++)
        {
            values[0][i] /= length;
            values[1][i] /= length;
        }
    }

    // convert the doubles into ruby numbers and stick them into a ruby array
    for(i = 0; i < length; i++)
    {
        rb_ary_push(xArray, DBL2NUM(values[0][i]));
        rb_ary_push(yArray, DBL2NUM(values[1][i]));
    }

    rb_ary_push(outArray, xArray);
    rb_ary_push(outArray, yArray);

    return outArray;
}

/**
 * @brief Prepare data to be processed.
 * This function converts a Ruby Array values into a C values to be processed
 * by perform_fft(). After processing FFT it returns it results.
 * @see perform_fft()
 * @author jude.sutton@gmail.com
 * @params inArray A Ruby input data array.
 * @params direction An FFT direction (1 - forward FFT, -1 - reverse FFT).
 * @return The output Ruby Array with FFT processed data.
 */
static VALUE prepare_fft(VALUE inArray, int direction)
{
    long i, length;
    VALUE * values;
    double ** transformed;
    VALUE outArray;

    if(!validate(inArray))
        return Qnil;

    // convert the ruby array into a C array of integers using NUM2DBL(Fixnum)
    values = RARRAY_PTR(inArray);
    length = RARRAY_LEN(values[0]);
    transformed = malloc(sizeof(double) * 2);
    transformed[0] = malloc(sizeof(double*) * RARRAY_LEN(values[0]));
    transformed[1] = malloc(sizeof(double*) * RARRAY_LEN(values[1]));
    for( i = 0; i < length; i++ ) {
        // process values
        transformed[0][i] = NUM2DBL(RARRAY_PTR(values[0])[i]);
        transformed[1][i] = NUM2DBL(RARRAY_PTR(values[1])[i]);
    }

    // do the actual transform
    outArray = perform_fft(transformed, length, direction);

    // no memory leaks
    free(transformed[0]);
    free(transformed[1]);
    free(transformed);

    return outArray;
}

/**
 * @brief Compute a forward FFT.
 * @author jude.sutton@gmail.com
 * @params self A Ruby input data array.
 * @return A result of forward FFT.
 */
static VALUE forward_fft(VALUE self)
{
    return prepare_fft(self, 1);
}

/**
 * @brief Compute a reverse FFT.
 * @author jude.sutton@gmail.com
 * @params self A Ruby input data array.
 * @return A result of reverse FFT.
 */
static VALUE reverse_fft(VALUE self)
{
    return prepare_fft(self, -1);
}

/**
 * @brief Initialize the FFTAPI module.
 * Initializes the module and defines methods.
 * @author jude.sutton@gmail.com
 */
VALUE FFT;
void Init_fft_api()
{
    FFT = rb_define_module("FFTAPI");
    rb_define_method(FFT, "fft", forward_fft, 0);
    rb_define_method(FFT, "rfft", reverse_fft, 0);
}
