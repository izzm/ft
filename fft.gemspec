Gem::Specification.new do |s|
  s.name        = "fft"
  s.version     = "0.2.0"
  s.date        = "2012-05-15"
  s.summary     = "Fast Fourier Transform for Ruby"
  s.description = "A C library to compute Discrete Fourier Transform (DFT) and Fast Fourier Transform (FFT) on one or two dimensional data for Ruby"
  s.authors     = ["Paweł Placzyński", "Jude Sutton"]
  s.email       = ["placek@ragnarson.com", "jude.sutton@gmail.com"]
  s.files       = `git ls-files`.split("\n")
  s.extensions  = ["ext/extconf.rb"]
  s.homepage    = "https://github.com/placek/FFT"
end
