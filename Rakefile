require 'rake'
require 'rake/packagetask'
require 'rake/classic_namespace'
require 'rbconfig'

desc "Run a Ruby file with JRuby"
task :start do
  file_name = ARGV.pop
  option = ENV_JAVA['os.name'] == 'Mac OS X' ? '-J-XstartOnFirstThread' : nil

  if File.exist? file_name
    sh "jruby #{option} #{file_name}"
  else
    puts 'File not found.'
  end
end

namespace :build do
  desc "Build Qt::JRuby jar"
  task :qtjruby do
    sh "jrubyc -t build -p org/qtjruby -d org/qtjruby org/qtjruby/main.rb"
    sh "ant"
  end
  
  desc "Build Qt::JRuby Java classes jar"
  task :java do
    sh "ant java"
  end
end