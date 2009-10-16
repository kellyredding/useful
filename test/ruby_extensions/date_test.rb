require File.dirname(__FILE__) + '/../test_helper'

class DateTest < Test::Unit::TestCase
  
  context "an extended Date" do
    setup do
      @date = Date.today
      @psat = Date.strptime('2009-10-10')
      @psun = Date.strptime('2009-10-11')
      @mon = Date.strptime('2009-10-12')
      @tue = Date.strptime('2009-10-13')
      @wed = Date.strptime('2009-10-14')
      @thr = Date.strptime('2009-10-15')
      @fri = Date.strptime('2009-10-16')
      @sat = Date.strptime('2009-10-17')
      @sun = Date.strptime('2009-10-18')
      @nmon = Date.strptime('2009-10-19')
      @ntue = Date.strptime('2009-10-20')
      @nwed = Date.strptime('2009-10-21')
    end
    subject { @date }
    
    should_have_instance_methods 'week_days_between'
    
    should "know how many week days are between it and another date" do
      assert_equal 0, @psun.week_days_between(@psun)
      assert_equal 1, @psun.week_days_between(@mon)
      assert_equal 2, @psun.week_days_between(@tue)
      assert_equal 3, @psun.week_days_between(@wed)
      assert_equal 4, @psun.week_days_between(@thr)
      assert_equal 5, @psun.week_days_between(@fri)
      assert_equal 5, @psun.week_days_between(@sat)
      assert_equal 5, @psun.week_days_between(@sun)
      assert_equal 6, @psun.week_days_between(@nmon)
      assert_equal 7, @psun.week_days_between(@ntue)
      assert_equal 8, @psun.week_days_between(@nwed)
      
      assert_equal 1, @mon.week_days_between(@mon)
      assert_equal 2, @mon.week_days_between(@tue)
      assert_equal 3, @mon.week_days_between(@wed)
    end

  end
  
end