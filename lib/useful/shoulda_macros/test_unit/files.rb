require 'useful/ruby_extensions/string' unless String.new.respond_to?(:constantize)

module Useful; end
module Useful::ShouldaMacros; end
module Useful::ShouldaMacros::TestUnit; end

module Useful::ShouldaMacros::TestUnit::Files
  
  protected
  
  def should_have_files(*files)
    the_files = files.flatten
    if the_files.empty?
      should "have @root_path" do
        assert @root_path, "the variable @root_path is not defined"
        assert File.exists?(@root_path), "'#{@root_path}' does not exist"
      end
    else
      the_files.each do |file|
        should "have the file '#{file}' in @root_path" do
          assert @root_path, "the variable @root_path is not defined"
          assert File.exists?(File.join(@root_path, file)), "'#{file}' does not exist in '#{@root_path}'"
        end
      end
    end
  end
  alias_method :should_have_directories, :should_have_files
  
end

Test::Unit::TestCase.extend(Useful::ShouldaMacros::TestUnit::Files) if defined? Test::Unit::TestCase
