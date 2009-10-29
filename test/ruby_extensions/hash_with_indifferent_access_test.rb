require File.dirname(__FILE__) + '/../test_helper'

class HashWithIndifferentAccessTest < Test::Unit::TestCase
  if defined?(HashWithIndifferentAccess)
    context "an extended HashWithIndifferentAccess" do
      setup do
        @hash = HashWithIndifferentAccess.new({ :one => 1, :two => 2, :three => 3, :a => 'a', :b => 'b', :c => 'c' })
        @nums = HashWithIndifferentAccess.new({ :one => 1, :two => 2, :three => 3 })
        @nums_string_keys = HashWithIndifferentAccess.new({ 'one' => 1, 'two' => 2, 'three' => 3 })
        @nums_keys = [:one, :two, :three]
        @abcs = HashWithIndifferentAccess.new({ :a => 'a', :b => 'b', :c => 'c' })
        @abcs_keys = [:a, :b, :c]
        @nilsish = HashWithIndifferentAccess.new({ :nil => nil, :string => '', :not => true, :array => [], :hash => {} })
        @nillified = HashWithIndifferentAccess.new({ :nil => nil, :string => nil, :not => true, :array => nil, :hash => nil })
      end
      subject { @hash }
    
    
      should_have_class_methods 'from_json'
    
      should "be able to be instantiated from a JSON string" do
        assert_equal @nums_string_keys, HashWithIndifferentAccess.from_json("{ \"one\": 1, \"two\": 2, \"three\": 3 }")
      end
    
    
      should_have_class_methods 'only', 'except', 'nillify'
      should_have_instance_methods 'only', 'only!', 'except', 'except!', 'nillify', 'nillify!'

      should "should only return certain keys at the class level" do
        assert_equal @nums, HashWithIndifferentAccess.only(subject, @nums_keys)
      end
      should "should only return certain keys at the instance level" do
        assert_equal @abcs, subject.only(@abcs_keys)
      end
      should "should destructively only return certain keys at the instance level" do
        subject.only!(@abcs_keys)
        assert_equal @abcs, subject
      end

      should "should return all keys except certain ones at the class level" do
        assert_equal @abcs, HashWithIndifferentAccess.except(subject, *@nums_keys)
      end
      should "should return all keys except certain ones at the instance level" do
        assert_equal @nums, subject.except(*@abcs_keys)
      end
      should "should destructively return all keys except certain ones at the instance level" do
        subject.except!(*@abcs_keys)
        assert_equal @nums, subject
      end

      should "should nillify at the class level" do
        assert_equal @nillified, HashWithIndifferentAccess.nillify(@nilsish)
      end
      should "should nillify at the instance level" do
        assert_equal @nillified, @nilsish.nillify
      end
      should "should destructively nillify at the instance level" do
        @nilsish.nillify!
        assert_equal @nillified, @nilsish
      end


      should_have_instance_methods 'get_value', 'search', 'check_value?'
    
      should "be able to get nested values" do
        @nested = HashWithIndifferentAccess.new({ 1 => { 2 => { 3 => 4 } } })
        assert_equal nil, @nested.get_value 
        assert_equal nil, @nested.get_value([])
        @expected = HashWithIndifferentAccess.new({ 2 => { 3 => 4 } })
        assert_equal @expected, @nested.get_value([1]) 
        @expected = HashWithIndifferentAccess.new({ 3 => 4 })
        assert_equal @expected, @nested.get_value([1,2]) 
        assert_equal 4, @nested.get_value([1,2,3]) 
      end
    
      should "be able to check nested values" do
        @nested = HashWithIndifferentAccess.new({ 1 => { 2 => { 3 => [], 4 => nil } } })
        assert !@nested.check_value?
        assert !@nested.check_value?([]) 
        assert @nested.check_value?([1]) 
        assert @nested.check_value?([1,2]) 
        assert !@nested.check_value?([1,2,3]) 
        assert !@nested.check_value?([1,2,4]) 
      end
    
    
      should_have_instance_methods 'to_http_query_str', 'to_html_attrs'

      should "be able to convert to proper http query string" do
        @expected = "?name=thomas%20hardy%20%2F%20thomas%20handy"
        assert_equal @expected, HashWithIndifferentAccess.new({:name => 'thomas hardy / thomas handy'}).to_http_query_str 
        @expected = "?id=23423&since=2009-10-14"
        assert_equal @expected, HashWithIndifferentAccess.new({:id => 23423, :since => "2009-10-14"}).to_http_query_str
        @expected = "?id[]=1&id[]=2"
        assert_equal @expected, HashWithIndifferentAccess.new({:id => [1,2]}).to_http_query_str
        @expected = "?poo[bar]=2&poo[foo]=1"
        assert_equal @expected, HashWithIndifferentAccess.new({:poo => {:foo => 1, :bar => 2}}).to_http_query_str
        @expected = "?poo[bar][bar1]=1&poo[bar][bar2]=nasty&poo[foo]=1"
        assert_equal @expected, HashWithIndifferentAccess.new({:poo => {:foo => 1, :bar => {:bar1 => 1, :bar2 => "nasty"}}}).to_http_query_str
        @expected = "name=johnson&this=suffix"
        assert_equal @expected, HashWithIndifferentAccess.new({:name => 'johnson'}).to_http_query_str(:prepend => '', :append => '&this=suffix')
      end

      should "be able to convert to proper html attribute string" do
        @expected = ""
        assert_equal @expected, HashWithIndifferentAccess.new({}).to_html_attrs 
        @expected = "class=\"test\" id=\"test_1\""
        assert_equal @expected, HashWithIndifferentAccess.new({:class => "test", :id => "test_1"}).to_html_attrs
      end


    end
  else
    should "pass b/c HashWithIndifferentAccess is not defined" do
      assert true
    end
  end
    
end