Dir.glob('{lib,gems/gems/*/lib}') { |lib| $:.push(lib) }
Dir.glob('jars/*') { |jar| require jar }

require 'qtjruby-core'
require ARGV.shift