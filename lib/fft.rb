require [File.dirname(__FILE__), '..', 'ext', 'fft_api'].join('/')

class Array
  include FFTAPI

  def fft2d
    size = self.first.size
    first_fft = [[],[]]
    size.times do |n|
      fft = [self.first[n], self.last[n]].fft
      first_fft.first << fft.first
      first_fft.last << fft.last
    end
    real, imag = first_fft
    first_fft = [real.transpose, imag.transpose]
    second_fft = [[],[]]
    size.times do |n|
      fft = [first_fft.first[n], first_fft.last[n]].fft
      second_fft.first << fft.first
      second_fft.last << fft.last
    end
    second_fft
  end
end
