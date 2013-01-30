require File.join(File.dirname(__FILE__), "..", "ext", "frequency_transformations")

class Array
  include FrequencyTransformations
end
