require File.dirname(__FILE__) + '/../test_helper'

class StringTest < Test::Unit::TestCase
  
  context "an extended String" do
    
    context "with a hash of key-values" do
      setup do
        @key_values = {:a => 'aye', :b => 'bee', :c => 'see'}
        @key_string = "Now I know my :a-:b-:c's..."
        @value_string = "Now I know my aye-bee-see's..."
      end

      should_have_class_methods 'hsub'
      should_have_instance_methods 'hsub', 'hsub!'
      should "support hash based substitution at the class level" do
        assert_equal @value_string, String.hsub(@key_string, @key_values)
      end
      should "support hash based substitution at the instance level" do
        assert_equal @value_string, @key_string.hsub(@key_values)
      end
      should "support destructive hash based substitution at the instance level" do
        @key_string.hsub!(@key_values)
        assert_equal @value_string, @key_string
      end
    end
    
    should_have_instance_methods 'empty!'
    should "support destructive emptying at the instance level" do
      s = "test"
      s.empty!
      assert_equal "", s
    end
    
    context "with content needing CGI escaping" do
      setup do
        @content = "escape\\this&string45%"
        @escaped_content = "escape%5Cthis%26string45%25"
      end
      
      should_have_class_methods 'cgi_escape'
      should_have_instance_methods 'cgi_escape', 'cgi_escape!'
      should "support cgi escaping at the class level" do
        assert_equal @escaped_content, String.cgi_escape(@content)
      end
      should "support cgi escaping at the instance level" do
        assert_equal @escaped_content, @content.cgi_escape
      end
      should "support destructive cgi escaping at the instance level" do
        @content.cgi_escape!
        assert_equal @escaped_content, @content
      end
      should "escape the ' ' char as %20" do
        @content << ' 1'
        @escaped_content << "%201"
        assert_equal @escaped_content, String.cgi_escape(@content)
      end
    end
    
    context "with a regular expression" do
      setup do
        @string_parts = ["the ", "kelredd", "-useful gem is awesome"]
        @match_re = /kelredd/
        @no_match_re = /sucks/
      end
      
      should_have_class_methods 'match?', 'valid_email?', 'show_regexp'
      should_have_instance_methods 'match?', 'valid_email?', 'show_regexp'
      should "answer match question at class level" do
        assert String.match?(@string_parts.join, @match_re)
        assert !String.match?(@string_parts.join, @no_match_re)
      end
      should "answer match question at instance level" do
        assert @string_parts.join.match?(@match_re)
        assert !@string_parts.join.match?(@no_match_re)
      end
      should "answer valid_email question at class level" do
        assert String.valid_email?("test@example.com")
        assert !String.valid_email?("@example.com")
        assert !String.valid_email?("*@example.com")
        assert !String.valid_email?("test@.com")
        assert !String.valid_email?("test@*.com")
        assert !String.valid_email?("test@example")
        assert !String.valid_email?("test@example.")
        assert !String.valid_email?("test@example.*")
        assert !String.valid_email?("test@example.1")
        assert !String.valid_email?("test@example.a")
      end
      should "answer valid_email question at instance level" do
        assert "test@example.com".valid_email?
        assert !"@example.com".valid_email?
      end
      should "show the regular expression at class level" do
        assert_equal @string_parts[0]+'<<'+@string_parts[1]+'>>'+@string_parts[2], String.show_regexp(@string_parts.join, @match_re)
        assert_equal "no match", String.show_regexp(@string_parts.join, @no_match_re)
      end
      should "show the regular expression at the instance level" do 
        assert_equal @string_parts[0]+'<<'+@string_parts[1]+'>>'+@string_parts[2], @string_parts.join.show_regexp(@match_re)
        assert_equal "no match", @string_parts.join.show_regexp(@no_match_re)
      end      
    end
    
    should_have_instance_methods 'to_boolean'
    should "be convertable to boolean" do 
      assert !"0".to_boolean
      assert !"false".to_boolean
      assert "1".to_boolean
      assert "true".to_boolean
      assert "2".to_boolean
      assert "poo".to_boolean
      assert "".to_boolean
    end
    
    should_have_instance_methods 'from_currency_to_f'
    should "be convertable to float from currency" do 
      assert_equal 1.0, "$1".from_currency_to_f
      assert_equal 1.0, "$000000001".from_currency_to_f
      assert_equal 1.0, "$1.0".from_currency_to_f
      assert_equal 1.0, "$1.000000".from_currency_to_f
      assert_equal 1.0, "$000000001".from_currency_to_f
      assert_equal 1.01, "$1.01".from_currency_to_f
      
      # does not round - its dumb
      assert_equal 1.015, "$1.015".from_currency_to_f

      # Note, only dollars-string aware
      # => just pulls out any numeric string parts and converts to float
      assert_equal 1.0, "1 dollar".from_currency_to_f
      assert_equal 1.0, "1 cent".from_currency_to_f
      assert_equal 2.0, "2 cents".from_currency_to_f
      assert_equal 1.0, "abba dabba 1 dabba doo".from_currency_to_f
    end
    
    context "with activesupport extensions" do
      
      should_have_class_methods 'camelize'
      should_have_instance_methods 'camelize', 'camelcase'
      should "camelize both at the class and instance levels" do
        assert_equal "ActiveRecord", String.camelize("active_record")
        assert_equal "ActiveRecord::Errors", String.camelize("active_record/errors")
        assert_equal "ActiveRecord", "active_record".camelize
        assert_equal "activeRecord", "active_record".camelize(:lower)
        assert_equal "ActiveRecord::Errors", "active_record/errors".camelize
        assert_equal "activeRecord::Errors", "active_record/errors".camelize(:lower)
      end
      
      should_have_class_methods 'classify'
      should_have_instance_methods 'classify'
      should "classify both at the class and instance levels" do
        assert_equal "ActiveRecord", String.classify("active_record")
        assert_equal "ActiveRecord::Errors", String.classify("active_record/errors")
        assert_equal "ActiveRecord::Error", String.classify("active_record/error")
        assert_equal "Error", String.classify("active_record.error")
        assert_equal "ActiveRecord", "active_record".classify
        assert_equal "ActiveRecord::Errors", "active_record/errors".classify
        assert_equal "ActiveRecord::Error", "active_record/error".classify
        assert_equal "Error", "active_record.error".classify
      end

      should_have_class_methods 'humanize'
      should_have_instance_methods 'humanize'
      should "humanize both at the class and instance levels" do
        assert_equal "Employee salary", String.humanize("employee_salary")
        assert_equal "Author", String.humanize("author_id")
        assert_equal "Employee salary", "employee_salary".humanize
        assert_equal "Author", "author_id".humanize
      end

      should_have_class_methods 'titleize'
      should_have_instance_methods 'titleize'
      should "titleize both at the class and instance levels" do
        assert_equal "Man From The Boondocks", String.titleize("man from the boondocks")
        assert_equal "X Men: The Last Stand", String.titleize("x-men: the last stand")
        assert_equal "Man From The Boondocks", "man from the boondocks".titleize
        assert_equal "X Men: The Last Stand", "x-men: the last stand".titleize
      end

      should_have_class_methods 'underscore'
      should_have_instance_methods 'underscore'
      should "underscore both at the class and instance levels" do
        assert_equal "active_record", String.underscore("ActiveRecord")
        assert_equal "active_record/errors", "ActiveRecord::Errors".underscore
      end

      should_have_class_methods 'dasherize'
      should_have_instance_methods 'dasherize'
      should "dasherize both at the class and instance levels" do
        assert_equal "active-record", String.dasherize("active_record")
        assert_equal "active-record is-awesome", "active_record is_awesome".dasherize
      end

      should_have_class_methods 'demodulize'
      should_have_instance_methods 'demodulize'
      should "demodulize both at the class and instance levels" do
        assert_equal "Inflections", String.demodulize("ActiveRecord::CoreExtensions::String::Inflections")
        assert_equal "Inflections", "Inflections".demodulize
      end

      should_have_class_methods 'constantize'
      should_have_instance_methods 'constantize'
      should "constantize both at the class and instance levels" do
        assert_equal String, String.constantize("String")
        assert_equal Hash, "Hash".constantize
        assert_equal Useful::RubyExtensions::String, "Useful::RubyExtensions::String".constantize
      end
      
      should_have_instance_methods 'ends_with?', 'starts_with?', 'to_datetime', 'to_date'
      
      should "know wheter it starts or ends with something" do
        assert "poopy pants".starts_with?("poo")
        assert !"poopy pants".starts_with?("pants")
        assert "poopy_pants".ends_with?('pants')
        assert !"poopy pants".ends_with?('poo')
      end
      
      should "be able to convert to dates and times" do
        assert_equal ::Date.strptime('2009-10-25'), "10/25/2009".to_date
        assert_equal ::DateTime.strptime('2009-10-25T15:30:00+00:00'), "10/25/2009 3:30 PM".to_datetime
      end

    end

  end
  
end