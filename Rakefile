require 'java'

require 'rake'
require 'rake/packagetask'
require 'rake/classic_namespace'
require 'rbconfig'

JRUBY_PLATFORM = Java::JavaLang::System.get_property('os.name')

namespace :jarify do
  desc "Jarify Qt Jambi JRuby Extensions"
  task :ext do
    system 'ant'
  end
end