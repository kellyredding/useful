require 'useful/ruby_extensions/string' unless String.new.respond_to?(:constantize)

module Useful; end
module Useful::ShouldaMacros; end
module Useful::ShouldaMacros::TestUnit; end

module Useful::ShouldaMacros::TestUnit::Classes
  
  protected
  
  # Ripped from Shoulda::ActiveRecord::Macros
  def should_have_instance_methods(*methods)
    get_options!(methods)
    klass = described_type
    methods.each do |method|
      should "respond to instance method ##{method}" do
        the_subject = begin
          klass.new
        rescue Exception => err
          subject
        end
        assert_respond_to(the_subject, method, "#{klass.name} does not have instance method #{method}")
      end
    end
  end unless Test::Unit::TestCase.method_defined? :should_have_instance_methods
  
  # Ripped from Shoulda::ActiveRecord::Macros
  def should_have_class_methods(*methods)
    get_options!(methods)
    klass = described_type
    methods.each do |method|
      should "respond to class method ##{method}" do
        assert_respond_to klass, method, "#{klass.name} does not have class method #{method}"
      end
    end
  end unless Test::Unit::TestCase.method_defined? :should_have_class_methods
  
  def should_have_readers(*readers)
    get_options!(readers)
    klass = described_type
    readers.each do |reader|
      should_have_instance_methods reader
    end
  end unless Test::Unit::TestCase.method_defined? :should_have_readers
  
  def should_have_writers(*writers)
    get_options!(writers)
    klass = described_type
    writers.each do |writer|
      should_have_instance_methods "#{writer}="
    end
  end unless Test::Unit::TestCase.method_defined? :should_have_writers
  
  def should_have_accessors(*accessors)
    get_options!(accessors)
    klass = described_type
    accessors.each do |accessor|
      should_have_instance_methods accessor, "#{accessor}="
    end
  end unless Test::Unit::TestCase.method_defined? :should_have_accessors
  
end

Test::Unit::TestCase.extend(Useful::ShouldaMacros::TestUnit::Classes) if defined? Test::Unit::TestCase
