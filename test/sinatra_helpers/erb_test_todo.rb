require File.dirname(__FILE__) + '/../test_helper'

class PartialsTest < Test::Unit::TestCase

  # TODO: unsure how to unit test with a Sinatra app
  # => need to do some research
  # => but this is the testing mindset
  
  context "the erb" do

    context "'partial' helper" do
      context "given foo and some bars" do
        setup do
          @locals = {:one => 1, :two => 2, :three => 3}
        end
        
        context "then the single foo partial" do
          setup do
            @foo = "abc"
            @empty_foo_str = "foo , locals: ,,"
            @foo_str = "foo abc, locals: ,,"
            @flocals_str = "foo , locals: 1,2,3"
            @foo_locals_str = "foo abc, locals: 1,2,3"
          end
          should "render" do
            assert_equal @empty_foo_str, partial('partials/foo')
          end
          should "render with no object but locals" do
            assert_equal @flocals_str, partial('partials/foo', :locals => @locals)
          end
          should "render with a local named after the partial" do
            assert_equal @foo_str, partial('partials/foo', :locals => {:foo => @foo})
          end
          should "render with an object but no locals" do
            assert_equal @foo_str, partial('partials/foo', :object => @foo)
          end
          should "render with an object and a local named after the partial" do
            assert_equal @foo_str, partial('partials/foo', :object => @foo, :locals => {:foo => "def"})
          end
          should "render with an object and locals" do
            assert_equal @foo_locals_str, partial('partials/foo', :object => @foo, :locals => @locals)
          end

        end
        
        context "then the collection of bar partials" do
          setup do
            @bars = [1,2,3]
            @bar_str = "bar 123, locals: ,,"
            @bar_locals_str = "bar 123, locals: 1,2,3"
          end
          should "render" do
            assert_equal @bar_str, partial('partials/bar', :collection => @bars)
          end
          should "render with an object" do
            assert_equal @bar_str, partial('partials/bar', :collection => @bars, :object => @foo)
          end
          should "render with a local named after the partial" do
            assert_equal @bar_str, partial('partials/bar', :collection => @bars, :locals => {:bar => 4})
          end
          should "render with locals" do
            assert_equal @bar_locals_str, partial('partials/bar', :collection => @bars, :locals => @locals)
          end
        end
        
      end
    end
    
  end

end