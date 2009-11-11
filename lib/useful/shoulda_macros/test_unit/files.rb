require 'useful/ruby_extensions/string' unless String.new.respond_to?(:constantize)

module Useful; end
module Useful::ShouldaMacros; end
module Useful::ShouldaMacros::TestUnit; end

module Useful::ShouldaMacros::TestUnit::Files
  
  protected
  
  def should_have_files(root_path, *files)
    the_files = files.flatten
    the_files.each do |file|
      should "have the file '#{file}' in '#{root_path}'" do
        assert File.exists?(File.join(root_path, file)), "'#{file}' does not exist in '#{root_path}'"
      end
    end
  end
  alias_method :should_have_directories, :should_have_files
  
end

Test::Unit::TestCase.extend(Useful::ShouldaMacros::TestUnit::Files) if defined? Test::Unit::TestCase
