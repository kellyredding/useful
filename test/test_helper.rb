# http://sneaq.net/textmate-wtf
$:.reject! { |e| e.include? 'TextMate' }

require 'rubygems'
require 'test/unit'
require 'shoulda/test_unit'

lib_path = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(lib_path) unless $LOAD_PATH.include?(lib_path)

require 'rack'  # for testing erb tags 'h_text' method
require 'useful/shoulda_macros/test_unit'

require 'useful/active_record_helpers'
require 'useful/cap_tasks'
require 'useful/rails_helpers'
require 'useful/sinatra_helpers'
require 'useful/erb_helpers'

require 'useful/ruby_extensions'
# Run all tests verifying that they play nice with active support
#require 'useful/ruby_extensions_with_activesupport'

