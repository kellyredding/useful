require File.dirname(__FILE__) + '/../test_helper'

class NumericTest < Test::Unit::TestCase
  
  context "an extended Numeric" do
    
    should_have_class_methods 'pad_precision'
    should "pad precision at the class level" do
      assert_equal "123.00", Numeric.pad_precision(123)
      assert_equal "123.00", Numeric.pad_precision(123.0)
      assert_equal "123.00", Numeric.pad_precision(123.00)
      assert_equal "123.40", Numeric.pad_precision(123.4)
      assert_equal "123.40", Numeric.pad_precision(123.40)
      assert_equal "123.45", Numeric.pad_precision(123.45)
      assert_equal "123", Numeric.pad_precision(123.45, :precision => 0)
      assert_equal "123.***", Numeric.pad_precision(123, :precision => 3, :pad_number => '*')
      assert_equal "123.4**", Numeric.pad_precision(123.4, :precision => 3, :pad_number => '*')
      assert_equal "123.45*", Numeric.pad_precision(123.45, :precision => 3, :pad_number => '*')
    end
    
    should_have_instance_methods 'with_delimiter'
    should "convert to string with delimiters" do
      assert_equal "12,345,678", 12345678.with_delimiter
      assert_equal "12,345,678.05", 12345678.05.with_delimiter
      assert_equal "12.345.678", 12345678.with_delimiter(:delimiter => ".")
      assert_equal "12,345,678", 12345678.with_delimiter(:seperator => ",")
      assert_equal "98 765 432,98", 98765432.98.with_delimiter(:delimiter => " ", :separator => ",")
    end
    
    should_have_instance_methods 'to_precision'
    should "convert to a specific precision" do
      assert_equal 123, 123.to_precision
      assert_equal 123, 123.0.to_precision
      assert_equal 123.1, 123.1.to_precision
      assert_equal 123.11, 123.11.to_precision
      assert_equal 123.11, 123.111.to_precision
      assert_equal 123.11, 123.114.to_precision
      assert_equal 123.12, 123.115.to_precision
      assert_equal 123.12, 123.119.to_precision
      assert_equal 123, 123.119.to_precision(0)
      assert_equal 123.1, 123.119.to_precision(1)
    end
    
    should_have_instance_methods 'with_precision'
    should "convert to a string with specific precision" do
      assert_equal "1111.23", 1111.2345.with_precision
      assert_equal "1,111.23", 1111.2345.with_precision(:delimiter => ',')
      assert_equal "111.235", 111.2345.with_precision(:precision => 3)
      assert_equal "13.00000", 13.with_precision(:precision => 5)
      assert_equal "389", 389.32314.with_precision(:precision => 0)
      assert_equal "1.111,235", 1111.2345.with_precision(:precision => 3, :separator => ',', :delimiter => '.')
    end
    
    should_have_instance_methods 'to_percentage'
    should "convert to a percentage string" do
      assert_equal "100.00%", 100.to_percentage
      assert_equal "100%", 100.to_percentage(:precision => 0)
      assert_equal "1.000,00%", 1000.to_percentage(:delimiter => '.', :separator => ',')
      assert_equal "302.24399%", 302.24398923423.to_percentage(:precision => 5)
    end
    
    should_have_instance_methods 'to_currency'
    should "convert to a currency string" do
      assert_equal "$1,234,567,890.50", 1234567890.50.to_currency
      assert_equal "$1,234,567,890.51", 1234567890.506.to_currency
      assert_equal "$1,234,567,890.506", 1234567890.506.to_currency(:precision => 3)
      assert_equal "&pound;1234567890,50", 1234567890.50.to_currency(:unit => "&pound;", :separator => ",", :delimiter => "")
      assert_equal "1234567890,50 &pound;", 1234567890.50.to_currency(:unit => "&pound;", :separator => ",", :delimiter => "", :format => "%n %u")
    end
    
    should_have_instance_methods 'to_storage_size'
    should "convert to a storage size string" do
      assert_equal "123 Bytes", 123.to_storage_size
      assert_equal "1.2 KB", 1234.to_storage_size
      assert_equal "12.1 KB", 12345.to_storage_size
      assert_equal "1.2 MB", 1234567.to_storage_size
      assert_equal "1.1 GB", 1234567890.to_storage_size
      assert_equal "1.1 TB", 1234567890123.to_storage_size
      assert_equal "1.18 MB", 1234567.to_storage_size(:precision => 2)
      assert_equal "473 KB", 483989.to_storage_size(:precision => 0)
      assert_equal "1,18 MB", 1234567.to_storage_size(:precision => 2, :separator => ',')
    end
    
    should_have_instance_methods 'to_parity'
    should "convert to a parity string" do
      assert_equal "odd", -1.to_parity
      assert_equal "even", 0.to_parity
      assert_equal "odd", 1.to_parity
      assert_equal "even", 2.to_parity
      assert_equal "even", 2.1.to_parity
      assert_equal "even", 2.9.to_parity
    end
    
    should_have_instance_methods 'to_phone'
    should "convert to a phone string" do
      assert_equal "555-1234", 5551234.to_phone
      assert_equal "123-555-1234", 1235551234.to_phone
      assert_equal "(123) 555-1234", 1235551234.to_phone(:area_code => true)
      assert_equal "123 555 1234", 1235551234.to_phone(:delimiter => " ")
      assert_equal "(123) 555-1234 x 555", 1235551234.to_phone(:area_code => true, :extension => 555)
      assert_equal "+1-123-555-1234", 1235551234.to_phone(:country_code => 1)
      assert_equal "+1.123.555.1234 x 1343", 1235551234.to_phone(:country_code => 1, :extension => 1343, :delimiter => ".")
    end
    
  end
  
end