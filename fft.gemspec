Gem::Specification.new do |s|
  s.name        = "fft"
  s.version     = "0.0.2"
  s.date        = "2012-05-10"
  s.summary     = "Fast Fourier Transform for Ruby"
  s.description = "A C library to compute Fast Fourier Transform (FFT) on one dimensional data for Ruby"
  s.authors     = ["Paweł Placzyński", "Jude Sutton"]
  s.email       = ["placek@ragnarson.com", "jude.sutton@gmail.com"]
  s.files       = `git ls-files`.split("\n")
  s.extensions  = ["ext/extconf.rb"]
  s.homepage    = "https://github.com/placek/FFT"
end
