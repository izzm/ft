Gem::Specification.new do |s|
  s.name        = "ft"
  s.version     = "1.0.0"
  s.date        = "2013-02-29"
  s.summary     = "Frequency Transforms for Ruby"
  s.description = "A C library to compute Discrete Hartley Transform (DHT), Fast Hartley Transform (FHT), Discrete Fourier Transform (DFT) and Fast Fourier Transform (FFT) for Ruby for 1D and 2D data"
  s.authors     = ["Paweł Placzyński", "Jude Sutton"]
  s.email       = ["placek@ragnarson.com", "jude.sutton@gmail.com"]
  s.files       = `git ls-files`.split("\n")
  s.extensions  = ["ext/extconf.rb"]
  s.homepage    = "https://github.com/placek/ft"
end
