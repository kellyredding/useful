# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{useful}
  s.version = "0.1.23"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Kelly Redding"]
  s.date = %q{2009-07-29}
  s.email = %q{kelly@kelredd.com}
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["README.rdoc", "Rakefile", "lib/useful", "lib/useful/active_record_helpers", "lib/useful/active_record_helpers/mysql_migration_helpers.rb", "lib/useful/active_record_helpers.rb", "lib/useful/cap_tasks", "lib/useful/cap_tasks/cache.rb", "lib/useful/cap_tasks/gemsconfig.rb", "lib/useful/cap_tasks/globals.rb", "lib/useful/cap_tasks.rb", "lib/useful/rails_extensions", "lib/useful/rails_extensions/environment_tests.rb", "lib/useful/rails_extensions.rb", "lib/useful/ruby_extensions", "lib/useful/ruby_extensions/array.rb", "lib/useful/ruby_extensions/date.rb", "lib/useful/ruby_extensions/false_class.rb", "lib/useful/ruby_extensions/fixnum.rb", "lib/useful/ruby_extensions/hash.rb", "lib/useful/ruby_extensions/numeric.rb", "lib/useful/ruby_extensions/object.rb", "lib/useful/ruby_extensions/string.rb", "lib/useful/ruby_extensions/true_class.rb", "lib/useful/ruby_extensions.rb", "lib/useful/ruby_extensions_from_rails", "lib/useful/ruby_extensions_from_rails/date.rb", "lib/useful/ruby_extensions_from_rails/duration.rb", "lib/useful/ruby_extensions_from_rails/fixnum.rb", "lib/useful/ruby_extensions_from_rails/hash.rb", "lib/useful/ruby_extensions_from_rails/numeric.rb", "lib/useful/ruby_extensions_from_rails/object.rb", "lib/useful/ruby_extensions_from_rails/string.rb", "lib/useful/ruby_extensions_from_rails/time.rb", "lib/useful/ruby_extensions_from_rails.rb", "lib/useful/sinatra_helpers", "lib/useful/sinatra_helpers/environment_tests.rb", "lib/useful/sinatra_helpers/erb", "lib/useful/sinatra_helpers/erb/error_pages.rb", "lib/useful/sinatra_helpers/erb/forms.rb", "lib/useful/sinatra_helpers/erb/helpers.rb", "lib/useful/sinatra_helpers/erb/links.rb", "lib/useful/sinatra_helpers/erb/partials.rb", "lib/useful/sinatra_helpers/erb/tags.rb", "lib/useful/sinatra_helpers/erb.rb", "lib/useful/sinatra_helpers/mailer", "lib/useful/sinatra_helpers/mailer/base.rb", "lib/useful/sinatra_helpers/mailer/exceptions.rb", "lib/useful/sinatra_helpers/mailer/tls.rb", "lib/useful/sinatra_helpers/mailer.rb", "lib/useful/sinatra_helpers.rb", "lib/useful/version.rb", "lib/useful.rb"]
  s.homepage = %q{code.kelredd.com}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{A collection of useful helpers for various ruby things.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<json>, [">= 0"])
      s.add_runtime_dependency(%q<tmail>, [">= 0"])
    else
      s.add_dependency(%q<json>, [">= 0"])
      s.add_dependency(%q<tmail>, [">= 0"])
    end
  else
    s.add_dependency(%q<json>, [">= 0"])
    s.add_dependency(%q<tmail>, [">= 0"])
  end
end
