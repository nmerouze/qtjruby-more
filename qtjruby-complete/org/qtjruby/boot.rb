file_path = ARGV.shift
root_path = File.dirname(file_path)
root_path = Dir.pwd unless File.exist?(root_path + '/gems')

Dir.glob(root_path + '/gems/*/lib') { |lib| $:.push(lib) }
Dir.glob(root_path + '/jars/*') { |jar| require jar }

require 'qtjruby-core'
require file_path