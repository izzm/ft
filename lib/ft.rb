require File.join(File.dirname(__FILE__), "..", "ext", "frequency_transformations")

class Array
  include FrequencyTransformations

  def dft2d
    perform_transformation(:dft)
  end

  def rdft2d
    perform_transformation(:rdft)
  end

  def fft2d
    perform_transformation(:fft)
  end

  def rfft2d
    perform_transformation(:rfft)
  end

  def dht2d
    perform_transformation(:dht)
  end

  def fht2d
    perform_transformation(:fht)
  end

  private

  def perform_transformation method
    transformed = self.map(&method).transpose
    transformed.map(&method)
  end

end
