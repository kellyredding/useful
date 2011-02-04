# Add test and lib paths to the $LOAD_PATH
[ File.dirname(__FILE__),
  File.join(File.dirname(__FILE__), '..', 'lib')
].each do |path|
  full_path = File.expand_path(path)
  $LOAD_PATH.unshift(full_path) unless $LOAD_PATH.include?(full_path)
end

require 'rack'  # for testing erb tags 'h_text' method
require 'useful/shoulda_macros/test_unit'

require 'useful/active_record_helpers'
require 'useful/cap_tasks'
require 'useful/rails_helpers'
require 'useful/erb_helpers'

require 'useful/ruby_extensions'
# Run all tests verifying that they play nice with active support
#require 'useful/ruby_extensions_with_activesupport'
