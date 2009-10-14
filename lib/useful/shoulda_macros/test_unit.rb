module Useful; end
module Useful::ShouldaMacros; end

module Useful::ShouldaMacros::TestUnit
  
  protected
  
  # Ripped from Shoulda::ActiveRecord::Macros
  def should_have_instance_methods(*methods)
    get_options!(methods)
    klass = described_type
    methods.each do |method|
      should "respond to instance method ##{method}" do
        assert_respond_to((klass.new rescue subject), method, "#{klass.name} does not have instance method #{method}")
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
  
end

Test::Unit::TestCase.extend(Useful::ShouldaMacros::TestUnit) if defined? Test::Unit::TestCase
