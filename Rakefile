require 'rake'
require 'rake/packagetask'
require 'rake/classic_namespace'
require 'rbconfig'

namespace :build do
  desc "Build Qt::JRuby jar"
  task :qtjruby do
    sh "jrubyc -t build -p org/qtjruby -d org/qtjruby org/qtjruby/main.rb"
    sh "ant"
  end
end