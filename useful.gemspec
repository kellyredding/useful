# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{useful}
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Kelredd"]
  s.date = %q{2009-06-02}
  s.email = %q{}
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["README.rdoc", "Rakefile", "lib/useful", "lib/useful/ruby_extensions", "lib/useful/ruby_extensions/array.rb", "lib/useful/ruby_extensions/fixnum.rb", "lib/useful/ruby_extensions/hash.rb", "lib/useful/ruby_extensions/numeric.rb", "lib/useful/ruby_extensions/object.rb", "lib/useful/ruby_extensions/string.rb", "lib/useful/ruby_extensions.rb", "lib/useful/sinatra_helpers", "lib/useful/sinatra_helpers/environment_tests.rb", "lib/useful/sinatra_helpers/erb", "lib/useful/sinatra_helpers/erb/error_pages.rb", "lib/useful/sinatra_helpers/erb/partials.rb", "lib/useful/sinatra_helpers/erb.rb", "lib/useful/sinatra_helpers/tags.rb", "lib/useful/sinatra_helpers.rb", "lib/useful/version.rb", "lib/useful.rb", "test/test_helper.rb", "test/unit", "test/unit/useful_test.rb"]
  s.has_rdoc = true
  s.homepage = %q{}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{A collection of useful helpers for various ruby things.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
