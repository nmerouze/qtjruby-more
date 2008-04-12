require 'java'

require 'core_ext/array'
require 'core_ext/module'
require 'core_ext/object'
require 'core_ext/string'

require 'qt/mapper'
require 'qt/dsl'
require 'qt/builder'
require 'qt/base'

module Qt
  extend Dsl::Application
end