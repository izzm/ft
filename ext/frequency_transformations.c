/**
 * @file frequency_transformations.c
 * @brief The C API for processing a Discrete Fourier Transform (DFT), Discrete Hartley Transform (DHT) and Fast Fourier Transform (FFT) for Ruby.
 * @author placek@ragnarson.com
 * @date 29.01.2013
 */
#include "ruby.h"
#include <math.h>
#include <stdlib.h>
#include <stdio.h>

#ifndef TRUE
#define TRUE 1
#define FALSE 0
#endif

/**
 * @brief This function validates the incoming array for transforms.
 * The array of data should contain complex numbers.
 * The function validates the length of incoming data
 * and reasures that the length is a power of 2.
 * Method will raise exception if array of data does not fit restrictions.
 * @author placek@ragnarson.com
 * @param self An array we work on.
 * @return The same array.
 */
static VALUE validate(VALUE self)
{
    int length, i;

    // check if instance of Array
    Check_Type(self, T_ARRAY);
    length = RARRAY_LEN(self);

    // make sure we have an array of complex numbers
    for( i = 0; i < length; i++ )
        Check_Type(RARRAY_PTR(self)[i], T_COMPLEX);

    // make sure the size of the array is a power of 2
    if( (length < 2) || (length & (length - 1)) )
        rb_raise(rb_eArgError, "expected to have size being a power of 2");

    return self;
}

/**
 * @brief Compute a DFT.
 * This function computes the DFT and returns the Ruby Array with the same size
 * and structure as input.
 * @see validate()
 * @author placek@ragnarson.com
 * @param values An array of processing data.
 * @params length Length of processing data.
 * @params direction An DFT direction (1 - forward DFT, -1 - reverse DFT).
 * @return An Ruby Array with DFT processed data.
 */
static VALUE perform_dft(double ** values, long length, int direction)
{
    long i, k;
    double arg;
    double cosarg, sinarg;
    double * temp_values[2];

    // prepare memory and result arrays
    VALUE output = rb_ary_new2(length);
    temp_values[0] = malloc(length * sizeof(double));
    temp_values[1] = malloc(length * sizeof(double));

    // do the calculations
    for(i = 0; i < length; i++)
    {
        temp_values[0][i] = 0;
        temp_values[1][i] = 0;
        arg = - direction * 2.0 * M_PI * (double)i / (double)length;
        for(k = 0; k < length; k++)
        {
            cosarg = cos(k * arg);
            sinarg = sin(k * arg);
            temp_values[0][i] += (values[0][k] * cosarg - values[1][k] * sinarg);
            temp_values[1][i] += (values[0][k] * sinarg + values[1][k] * cosarg);
        }
    }

    // copy data to final arrays, process for inverse transform
    if(direction == -1)
    {
        for(i = 0; i < length; i++)
        {
            rb_ary_push(output, rb_complex_new(
                  DBL2NUM(temp_values[0][i] / (double)length),
                  DBL2NUM(temp_values[1][i] / (double)length)));
        }
    } else {
        for(i = 0; i < length; i++)
        {
            rb_ary_push(output, rb_complex_new(
                  DBL2NUM(temp_values[0][i]),
                  DBL2NUM(temp_values[1][i])));
        }
    }

    // free the memory
    free(temp_values[0]);
    free(temp_values[1]);

    return output;
}

/**
 * @brief Compute a FFT.
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
    VALUE output = rb_ary_new2(length);

    unsigned int position, target, mask, jump;
    unsigned int step, group, pair, i;
    double multiplier_real, multiplier_imag, factor_real, factor_imag, product_real, product_imag;
    double temp_real, temp_imag, delta, sine, pi = direction * (-M_PI);
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
        rb_ary_push(output, rb_complex_new(
              DBL2NUM(values[0][i]),
              DBL2NUM(values[1][i])));
    }

    return output;
}

/**
 * @brief Prepare data to be processed.
 * This function converts a Ruby Array values into a C values to be processed
 * by perform_dft(). After processing DFT it returns it results.
 * @see perform_dft()
 * @author placek@ragnarson.com
 * @params input A Ruby input data array.
 * @params direction An DFT direction (1 - forward DFT, -1 - reverse DFT).
 * @return The output Ruby Array with DFT processed data.
 */
static VALUE prepare_dft(VALUE input, int direction)
{
    long i, length;
    VALUE * values;
    double ** transformed;
    VALUE output;

    // validate array
    values = RARRAY_PTR(validate(input));

    // convert the ruby array into a C array of integers using NUM2DBL(Float)
    length = RARRAY_LEN(input);
    transformed = malloc(sizeof(double) * 2);
    transformed[0] = malloc(sizeof(double*) * length);
    transformed[1] = malloc(sizeof(double*) * length);

    // process values
    for( i = 0; i < length; i++ )
    {
        transformed[0][i] = NUM2DBL(RCOMPLEX(values[i])->real);
        transformed[1][i] = NUM2DBL(RCOMPLEX(values[i])->imag);
    }

    // do the actual transform
    output = perform_dft(transformed, length, direction);

    // no memory leaks
    free(transformed[0]);
    free(transformed[1]);
    free(transformed);

    return output;
}

/**
 * @brief Prepare data to be processed.
 * This function converts a Ruby Array values into a C values to be processed
 * by perform_fft(). After processing FFT it returns it results.
 * @see perform_fft()
 * @author placek@ragnarson.com
 * @params input A Ruby input data array.
 * @params direction An FFT direction (1 - forward FFT, -1 - reverse FFT).
 * @return The output Ruby Array with FFT processed data.
 */
static VALUE prepare_fft(VALUE input, int direction)
{
    long i, length;
    VALUE * values;
    double ** transformed;
    VALUE output;

    // validate array
    values = RARRAY_PTR(validate(input));

    // convert the ruby array into a C array of integers using NUM2DBL(Float)
    length = RARRAY_LEN(input);
    transformed = malloc(sizeof(double) * 2);
    transformed[0] = malloc(sizeof(double*) * length);
    transformed[1] = malloc(sizeof(double*) * length);

    // process values
    for( i = 0; i < length; i++ )
    {
        transformed[0][i] = NUM2DBL(RCOMPLEX(values[i])->real);
        transformed[1][i] = NUM2DBL(RCOMPLEX(values[i])->imag);
    }

    // do the actual transform
    output = perform_fft(transformed, length, direction);

    // no memory leaks
    free(transformed[0]);
    free(transformed[1]);
    free(transformed);

    return output;
}

/**
 * @brief Get phase array.
 * This function grabs the array of phase values.
 * @author placek@ragnarson.com
 * @params input A Ruby input data array.
 * @return The output Ruby Array with phase values.
 */
static VALUE phase(VALUE input)
{
    long i, length;
    VALUE * values;
    double real, imag;
    VALUE output;

    // validate array
    values = RARRAY_PTR(validate(input));

    // convert the ruby array into a C array of integers using NUM2DBL(Fixnum)
    length = RARRAY_LEN(input);
    output = rb_ary_new2(length);

    // process values
    for( i = 0; i < length; i++ )
    {
        real = NUM2DBL(RCOMPLEX(values[i])->real);
        imag = NUM2DBL(RCOMPLEX(values[i])->imag);
        rb_ary_push(output, DBL2NUM(atan2(real, imag)));
    }

    return output;
}

/**
 * @brief Get magnitude array.
 * This function grabs the array of magnitude values.
 * @author placek@ragnarson.com
 * @params inArray A Ruby input data array.
 * @return The output Ruby Array with magnitude values.
 */
static VALUE magnitude(VALUE input)
{
    long i, length;
    VALUE * values;
    double real, imag;
    VALUE output;

    // validate array
    values = RARRAY_PTR(validate(input));

    // convert the ruby array into a C array of integers using NUM2DBL(Fixnum)
    length = RARRAY_LEN(input);
    output = rb_ary_new2(length);

    // process values
    for( i = 0; i < length; i++ )
    {
        real = NUM2DBL(RCOMPLEX(values[i])->real);
        imag = NUM2DBL(RCOMPLEX(values[i])->imag);
        rb_ary_push(output, DBL2NUM(sqrt(real * real + imag * imag)));
    }

    return output;
}

///**
// * @brief Prepare data and switch quarters.
// * This function switches quarters for further frequency processing.
// * @author placek@ragnarson.com
// * @params input A Ruby input data array.
// * @return The output Ruby Array with switched data.
// */
//static VALUE switch_quarters(VALUE input)
//{
//    long length_x, length_y;
//    long i, j;
//    VALUE * values, output;
//    double ** temp_values, temp;
//
//    // validate types and get dimensions
//    Check_Type(input, T_ARRAY);
//    values = RARRAY_PTR(input);
//    length_y = RARRAY_LEN(input);
//    for( i = 0; i < length_y; i++ )
//        Check_Type(values[i], T_ARRAY);
//    length_x = RARRAY_LEN(values[0]);
//    for( i = 1; i < length_y; i++ )
//        if( length_x != RARRAY_LEN(values[i]) )
//            rb_raise(rb_eArgError, "expected an array of arrays with the same size");
//
//    // initialize output
//    output = rb_ary_new2(length_y);
//
//    // TODO:
//    // get values
//    temp_values = (double**)malloc(length_y * sizeof(double*));
//    for(j = 0; j < length_y; j++)
//    {
//        temp_values[j] = (double*)malloc(length_x * sizeof(double));
//        for(i = 0; i < length_x; i++)
//            temp_values[j][i] = NUM2DBL(RARRAY_PTR(values[j])[i]);
//    }
//
//    // process switching
//    for(i = 0; i < length_x / 2; i++)
//        for(j = 0; j < length_y / 2; j++)
//        {
//            temp = temp_values[j][i];
//            temp_values[j][i] = temp_values[j + length_y / 2][i + length_x / 2];
//            temp_values[j + length_y / 2][i + length_x / 2] = temp;
//        }
//
//    for(i = length_x / 2; i < length_x; i++)
//        for(j = 0; j < length_y / 2; j++)
//        {
//            temp = temp_values[j][i];
//            temp_values[j][i] = temp_values[j + length_y / 2][i - length_x / 2];
//            temp_values[j + length_y / 2][i - length_x / 2] = temp;
//        }
//
//    // rewrite values to ruby table
//    for(j = 0; j < length_y; j++)
//    {
//        VALUE tempArray = rb_ary_new2(length_x);
//        for(i = 0; i < length_x; i++)
//            rb_ary_push(tempArray, DBL2NUM(temp_values[j][i]));
//        rb_ary_push(output, tempArray);
//        free(temp_values[j]);
//    }
//    free(temp_values);
//
//    return output;
//}

/**
 * @brief Compute a forward DFT.
 * @author jude.sutton@gmail.com
 * @params self A Ruby input data array.
 * @return A result of forward DFT.
 */
static VALUE forward_dft(VALUE self)
{
    return prepare_dft(self, 1);
}

/**
 * @brief Compute a reverse DFT.
 * @author jude.sutton@gmail.com
 * @params self A Ruby input data array.
 * @return A result of reverse DFT.
 */
static VALUE reverse_dft(VALUE self)
{
    return prepare_dft(self, -1);
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

VALUE FT;
void Init_frequency_transformations()
{
    FT = rb_define_module("FrequencyTransformations");
    rb_define_method(FT, "validate", validate, 0);
    rb_define_method(FT, "dft", forward_dft, 0);
    rb_define_method(FT, "rdft", reverse_dft, 0);
    rb_define_method(FT, "fft", forward_fft, 0);
    rb_define_method(FT, "rfft", reverse_fft, 0);
    rb_define_method(FT, "magnitude", magnitude, 0);
    rb_define_method(FT, "phase", phase, 0);
}
