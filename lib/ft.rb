require [File.dirname(__FILE__), '..', 'ext', 'frequency_transformations'].join('/')

class Array
  include FrequencyTransformations

  def dft2d
    perform_fourier2d(:dft)
  end

  def rdft2d
    perform_fourier2d(:rdft)
  end

  def fft2d
    perform_fourier2d(:fft)
  end

  def rfft2d
    perform_fourier2d(:rfft)
  end

  private

  def perform_fourier2d method
    size = self.first.size
    first_part = [[],[]]
    size.times do |n|
      transformed = [self.first[n], self.last[n]].send(method)
      first_part.first << transformed.first
      first_part.last << transformed.last
    end
    real, imag = first_part
    first_part = [real.transpose, imag.transpose]
    second_part = [[],[]]
    size.times do |n|
      transformed = [first_part.first[n], first_part.last[n]].send(method)
      second_part.first << transformed.first
      second_part.last << transformed.last
    end
    second_part
  end

end
