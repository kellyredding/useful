require 'rubygems'
require 'rake/gempackagetask'
require 'rake/testtask'

require 'lib/useful/version'

task :default => :test

spec = Gem::Specification.new do |s|
  s.name             = 'kelredd-useful'
  s.version          = Useful::Version.to_s
  s.has_rdoc         = true
  s.extra_rdoc_files = %w(README.rdoc)
  s.rdoc_options     = %w(--main README.rdoc)
  s.summary          = "A collection of useful helpers for various ruby things."
  s.author           = 'Kelly Redding'
  s.email            = 'kelly@kelredd.com'
  s.homepage         = 'http://code.kelredd.com'
  s.files            = %w(README.rdoc Rakefile) + Dir.glob("{lib}/**/*")
  # s.executables    = ['useful']
  
  s.add_dependency('json')
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc 'Generate the gemspec to serve this Gem from Github'
task :gemspec do
  file = File.dirname(__FILE__) + "/#{spec.name}.gemspec"
  File.open(file, 'w') {|f| f << spec.to_ruby }
  puts "Created gemspec: #{file}"
end

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList["test/**/*_test.rb"]
  t.verbose = true
end
