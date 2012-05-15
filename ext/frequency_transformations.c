/**
 * @file frequency_transformations.c
 * @brief The C API for processing a Discrete Fourier Transform (DFT), Discrete Hartley Transform (DHT) and Fast Fourier Transform (FFT) for Ruby.
 * Forked from https://github.com/slowjud/FFT
 * @author jude.sutton@gmail.com, placek@ragnarson.com
 * @date 15.05.2012
 */
#include "ruby.h"
#include <math.h>
#include <stdlib.h>

#ifndef TRUE
#define TRUE 1
#define FALSE 0
#endif

/**
 * @brief This function validates the incoming array for Fourier transforms.
 * The array of data should contain two arrays: the first one with real parts
 * and the second one with imaginary parts of processing data.
 * The function validates the length of incoming data, the length of inner arrays
 * and reasures that the length is a power of 2.
 * @author jude.sutton@gmail.com
 * @param self An array we work on.
 * @return A validation result (1 if passed, 0 if failed).
 */
static int fourier_validate(VALUE self)
{
    long length;
    VALUE * values = RARRAY_PTR(self);

    // check if instance of Array
    Check_Type(self, T_ARRAY);

    // make sure we have an array of two arrays
    if(RARRAY_LEN(self) != 2) return FALSE;

    // make sure the arrays are of the same length
    if(RARRAY_LEN( values[0]) != RARRAY_LEN(values[1])) return FALSE;

    // make sure the size of the array is a power of 2
    length = RARRAY_LEN(values[0]);
    if((length < 2) || (length & (length - 1))) return FALSE;

    return TRUE;
}

/**
 * @brief This function validates the incoming array for Hartley transforms.
 * The array of data should contain only numbers. The length of array
 * should be a multiplication of 2.
 * @author placek@ragnarson.com
 * @param self An array we work on.
 * @return A validation result (1 if passed, 0 if failed).
 */
static int hartley_validate(VALUE self)
{
    long length;
    VALUE * values = RARRAY_PTR(self);

    // check if instance of Array
    Check_Type(self, T_ARRAY);

    // make sure we have an array of at least one number
    if(RARRAY_LEN(self) < 0) return FALSE;

    // check length of an array
    if(RARRAY_LEN(self) % 2 == 1) return FALSE;

    return TRUE;
}

/**
 * @brief Compute a FFT.
 * This function computes the FFT and returns the Ruby Array with the same size
 * and structure as input.
 * @see fourier_validate()
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
        rb_ary_push(xArray, DBL2NUM(values[0][i]));
        rb_ary_push(yArray, DBL2NUM(values[1][i]));
    }

    rb_ary_push(outArray, xArray);
    rb_ary_push(outArray, yArray);

    return outArray;
}

/**
 * @brief Compute a DFT.
 * This function computes the DFT and returns the Ruby Array with the same size
 * and structure as input.
 * @see fourier_validate()
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
    VALUE outArray = rb_ary_new2(2);
    VALUE xArray = rb_ary_new2(length);
    VALUE yArray = rb_ary_new2(length);
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
            rb_ary_push(xArray, DBL2NUM(temp_values[0][i] / (double)length));
            rb_ary_push(yArray, DBL2NUM(temp_values[1][i] / (double)length));
        }
    } else {
        for(i = 0; i < length; i++)
        {
            rb_ary_push(xArray, DBL2NUM(temp_values[0][i]));
            rb_ary_push(yArray, DBL2NUM(temp_values[1][i]));
        }
    }

    // free the memory
    free(temp_values[0]);
    free(temp_values[1]);

    // prepare result and return it
    rb_ary_push(outArray, xArray);
    rb_ary_push(outArray, yArray);

    return outArray;
}

/**
 * @brief Compute a FHT.
 * This function computes the FHT and returns the Ruby Array with the same size
 * as input.
 * @see hartley_validate()
 * @author placek@ragnarson.com
 * @param values An array of processing data.
 * @params length Length of processing data.
 * @return An Ruby Array with FHT processed data.
zo */
static VALUE perform_fht(double * values, long length)
{
    long i, k, scale = 1;
    long level, group, position, match, arg;
    double a, b, sqrt_length = sqrt(length);
    double * C, * S;

    // prepare memory and result array
    VALUE outArray = rb_ary_new2(length);

    // prepare table of cosines and sines
    C = malloc(length / 2 * sizeof(double));
    S = malloc(length / 2 * sizeof(double));
    arg = 2.0 * M_PI / (double)length;
    for(k = 0; k < length / 2; k++)
    {
        C[k] = cos(arg * (double)k);
        S[k] = sin(arg * (double)k);
    }

    // calculate scale
    for(i = length; i > 2; i >>= 1)
        scale <<= 1;

    for(level = 2; level <= length; level <<= 1)
    {
        for(group = 0; group < length; group += level)
        {
            i = 1;
            for(position = group + level / 2 + 1, match = group + level - 1; position < match; position++, match--)
            {
                k = i * scale;
                i++;
                a = values[position];
                b = values[match];
                values[position] = a * C[k] + b * S[k];
                values[match] = a * S[k] - b * C[k];
            }
            for(position = group, match = group + level / 2; match < group + level; position++, match++)
            {
                a = values[position];
                b = values[match];
                values[position] = a + b;
                values[match] = a - b;
            }
        }
        scale >>= 1;
    }

    // put values into ruby array
    for(i = 0; i < length; i++)
        rb_ary_push(outArray, DBL2NUM(values[i] / sqrt_length));

    // free the memory
    free(C);
    free(S);

    return outArray;
}

/**
 * @brief Compute a DHT.
 * This function computes the DHT and returns the Ruby Array with the same size
 * as input.
 * @see hartley_validate()
 * @author placek@ragnarson.com
 * @param values An array of processing data.
 * @params length Length of processing data.
 * @return An Ruby Array with DHT processed data.
zo */
static VALUE perform_dht(double * values, long length)
{
    long i, k;
    double arg, cos_arg, sin_arg, sqrt_length = sqrt(length);
    double * temp_values;

    // prepare memory and result array
    VALUE outArray = rb_ary_new2(length);
    temp_values = malloc(length * sizeof(double));

    // do the calculations
    for(i = 0; i < length; i++)
    {
        temp_values[i] = 0.0;
        arg = 2.0 * M_PI * (double)i / (double)length;
        for(k = 0; k < length; k++)
        {
            cos_arg = cos((double)k * arg);
            sin_arg = sin((double)k * arg);
            temp_values[i] += values[k] * (sin_arg + cos_arg);
        }
        temp_values[i] /= sqrt_length;
    }

    // put values into ruby array
    for(i = 0; i < length; i++)
        rb_ary_push(outArray, DBL2NUM(temp_values[i]));

    // free the memory
    free(temp_values);

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

    if(!fourier_validate(inArray))
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
 * @brief Prepare data to be processed.
 * This function converts a Ruby Array values into a C values to be processed
 * by perform_dft(). After processing DFT it returns it results.
 * @see perform_dft()
 * @author jude.sutton@gmail.com
 * @params inArray A Ruby input data array.
 * @params direction An DFT direction (1 - forward DFT, -1 - reverse DFT).
 * @return The output Ruby Array with DFT processed data.
 */
static VALUE prepare_dft(VALUE inArray, int direction)
{
    long i, length;
    VALUE * values;
    double ** transformed;
    VALUE outArray;

    if(!fourier_validate(inArray))
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
    outArray = perform_dft(transformed, length, direction);

    // no memory leaks
    free(transformed[0]);
    free(transformed[1]);
    free(transformed);

    return outArray;
}

/**
 * @brief Prepare data to be processed.
 * This function converts a Ruby Array values into a C values to be processed
 * by perform_fht(). After processing DHT it returns it results.
 * @see perform_fht()
 * @author placek@ragnarson.com
 * @params inArray A Ruby input data array.
 * @return The output Ruby Array with FHT processed data.
 */
static VALUE prepare_fht(VALUE inArray)
{
    long i, length;
    VALUE * values;
    double * transformed;
    VALUE outArray;

    if(!hartley_validate(inArray))
        return Qnil;

    // convert the ruby array into a C array of integers using NUM2DBL(Fixnum)
    values = RARRAY_PTR(inArray);
    length = RARRAY_LEN(inArray);
    transformed = malloc(sizeof(double) * length);
    for(i = 0; i < length; i++)
        transformed[i] = NUM2DBL(values[i]);

    // do the actual transform
    outArray = perform_fht(transformed, length);

    // no memory leaks
    free(transformed);

    return outArray;
}

/**
 * @brief Prepare data to be processed.
 * This function converts a Ruby Array values into a C values to be processed
 * by perform_dht(). After processing DHT it returns it results.
 * @see perform_dht()
 * @author placek@ragnarson.com
 * @params inArray A Ruby input data array.
 * @return The output Ruby Array with DHT processed data.
 */
static VALUE prepare_dht(VALUE inArray)
{
    long i, length;
    VALUE * values;
    double * transformed;
    VALUE outArray;

    if(!hartley_validate(inArray))
        return Qnil;

    // convert the ruby array into a C array of integers using NUM2DBL(Fixnum)
    values = RARRAY_PTR(inArray);
    length = RARRAY_LEN(inArray);
    transformed = malloc(sizeof(double) * length);
    for(i = 0; i < length; i++)
        transformed[i] = NUM2DBL(values[i]);

    // do the actual transform
    outArray = perform_dht(transformed, length);

    // no memory leaks
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
 * @brief Compute a forward FHT.
 * @author jude.sutton@gmail.com
 * @params self A Ruby input data array.
 * @return A result of forward FHT.
 */
static VALUE forward_fht(VALUE self)
{
    return prepare_fht(self);
}

/**
 * @brief Compute a forward DHT.
 * @author jude.sutton@gmail.com
 * @params self A Ruby input data array.
 * @return A result of forward DHT.
 */
static VALUE forward_dht(VALUE self)
{
    return prepare_dht(self);
}

/**
 * @brief Initialize the FrequencyTransformations module.
 * Initializes the module and defines methods.
 * @author placek@ragnarson.com
 */
VALUE FT;
void Init_frequency_transformations()
{
    FT = rb_define_module("FrequencyTransformations");
    rb_define_method(FT, "fft", forward_fft, 0);
    rb_define_method(FT, "rfft", reverse_fft, 0);
    rb_define_method(FT, "dft", forward_dft, 0);
    rb_define_method(FT, "rdft", reverse_dft, 0);
    rb_define_method(FT, "dht", forward_dht, 0);
    rb_define_method(FT, "fht", forward_fht, 0);
}
