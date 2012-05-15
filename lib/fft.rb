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

  def rfft2d
    size = self.first.size
    first_fft = [[],[]]
    size.times do |n|
      fft = [self.first[n], self.last[n]].rfft
      first_fft.first << fft.first
      first_fft.last << fft.last
    end
    real, imag = first_fft
    first_fft = [real.transpose, imag.transpose]
    second_fft = [[],[]]
    size.times do |n|
      fft = [first_fft.first[n], first_fft.last[n]].rfft
      second_fft.first << fft.first
      second_fft.last << fft.last
    end
    second_fft
  end

  def dft2d
    size = self.first.size
    first_dft = [[],[]]
    size.times do |n|
      dft = [self.first[n], self.last[n]].dft
      first_dft.first << dft.first
      first_dft.last << dft.last
    end
    real, imag = first_dft
    first_dft = [real.transpose, imag.transpose]
    second_dft = [[],[]]
    size.times do |n|
      dft = [first_dft.first[n], first_dft.last[n]].dft
      second_dft.first << dft.first
      second_dft.last << dft.last
    end
    second_dft
  end

  def rdft2d
    size = self.first.size
    first_dft = [[],[]]
    size.times do |n|
      dft = [self.first[n], self.last[n]].rdft
      first_dft.first << dft.first
      first_dft.last << dft.last
    end
    real, imag = first_dft
    first_dft = [real.transpose, imag.transpose]
    second_dft = [[],[]]
    size.times do |n|
      dft = [first_dft.first[n], first_dft.last[n]].rdft
      second_dft.first << dft.first
      second_dft.last << dft.last
    end
    second_dft
  end

end
