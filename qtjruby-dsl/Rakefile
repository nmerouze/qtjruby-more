require 'rake'
require 'rake/gempackagetask'

windows = (ENV_JAVA['os.name'] =~ /Windows/) rescue nil
SUDO = windows ? "" : "sudo"

NAME = 'qtjruby-dsl'
VERSION = '0.2.0'

task :default => :install

spec = Gem::Specification.new do |s|
  s.name         = NAME
  s.version      = VERSION
  s.platform     = Gem::Platform::RUBY
  s.author       = "Nicolas Mérouze"
  s.email        = "nicolas.merouze@gmail.com"
  s.homepage     = "http://www.qtjruby.org"
  s.summary      = "Qt meets Java meets Ruby."
  s.description  = s.summary
  s.require_path = "lib"
  s.files        = %w( LICENSE README.textile Rakefile ) + Dir["{bin,lib}/**/*"]
  s.add_dependency 'qtjruby-core', '>= 0.2.0'

  # rdoc
  s.has_rdoc         = false
end

Rake::GemPackageTask.new(spec) do |package|
  package.gem_spec = spec
end

task :install => :package do
  sh %{#{SUDO} #{ENV_JAVA['jruby.home']}/bin/jruby -S gem install pkg/#{NAME}-#{VERSION}.gem --no-rdoc --no-ri}
end