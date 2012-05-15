require 'mkmf'

def error msg
  message msg + "\n"
  abort
end

create_makefile('frequency_transformations')
