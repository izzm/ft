require [File.dirname(__FILE__), '..', 'ext', 'fft_api'].join('/')

class Array
  include FFTAPI
end
