require File.dirname(__FILE__) + '/../test_helper'

class LinksTest < Test::Unit::TestCase
  
  include Useful::ErbHelpers::Links

  context "the erb link_to helper" do
    setup do 
      @link_content = "Da Googs"
      @link_href = "http://www.google.com"
      @link_options = {:class => 'awesome'}
    end

    context "'link_to'" do
      should "render with just a url" do
        assert_equal tag(:a, :href => @link_href) { @link_href }, link_to(@link_href)
      end
      should "render with a label" do
        assert_equal tag(:a, :href => @link_href) { @link_content }, link_to(@link_content, @link_href)
      end
      should "render with html options" do
        assert_equal tag(:a, @link_options.merge(:href => @link_href)) { @link_content }, link_to(@link_content, @link_href, @link_options)
      end
    end

    context "'open_link_to'" do
      should "render" do
        link_tag = link_to(@link_content, @link_href, @link_options.merge(:onclick => "javascript: window.open('#{@link_href}'); return false;"))
        assert_equal link_tag, open_link_to(@link_content, @link_href, @link_options)
      end
    end

    context "'mail_link_to'" do
      should "render" do
        email = "kelly@kelredd.com"
        link_tag = link_to(@link_content, "mailto: #{email}", @link_options)
        assert_equal link_tag, mail_link_to(@link_content, email, @link_options)
      end
    end

    context "'link_to_function'" do
      should "render" do
        function = "alert('awesome');"
        @link_options[:href] = 'javascript: void(0);'
        @link_options[:onclick] = "javascript: #{function}; return false;"
        link_tag = link_to(@link_content, @link_options[:href], @link_options)
        assert_equal link_tag, link_to_function(@link_content, function, @link_options)
      end
    end
  end

  context "the erb helper" do
    context "'image_tag'" do
      setup do
        @opts = {:class => 'awesome'}
        @img_name = "charles.jpg"
        @img_def_src = "/images/#{@img_name}"
        @img_cust_src = "/in_charge/#{@img_name}"
      end
      should "render without a path" do
        assert_equal tag(:img, @opts.merge(:src => @img_def_src)), image_tag(@img_name, @opts)
      end
      should "render with a path" do
        assert_equal tag(:img, @opts.merge(:src => @img_cust_src)), image_tag(@img_cust_src, @opts)
      end
    end
    
    context "'stylesheet_link_tag'" do
      setup do
        @opts = {
          :rel => "stylesheet",
          :type => "text/css",
          :media =>  "all"          
        }
        @def = ['default', "/stylesheets/default.css"]
        @test = ['test', "/stylesheets/test.css"]
        @def_dev_match = /default.css\?[0-9]+/
      end
      should "render a single link" do
        @opts[:href] = @def[1]
        assert_equal tag(:link, @opts), stylesheet_link_tag(@def[0])
      end
      should "render a development environment link" do
        assert_match @def_dev_match, stylesheet_link_tag('default', :environment => 'development')
      end
      should "render a single link with options" do
        @opts[:media] = 'screen'
        @opts[:href] = @def[1]
        assert_equal tag(:link, @opts), stylesheet_link_tag(@def[0], :media => 'screen')
      end
      context "with two stylsheets and options" do
        setup do
          @opts[:media] = 'screen'
          @tags = []
          @opts[:href] = @def[1]
          @tags << tag(:link, @opts)
          @opts[:href] = @test[1]
          @tags << tag(:link, @opts)
        end
        should "render if sheets passed as args" do
          assert_equal @tags.join("\n"), stylesheet_link_tag(@def[0], @test[0], :media => 'screen')
        end
        should "render if sheets passed as an array" do
          assert_equal @tags.join("\n"), stylesheet_link_tag([@def[0], @test[0]], :media => 'screen')
        end
      end
      context "with three stylsheets referenced differently" do
        setup do
          @other = ['/other_stylesheets/other', "/other_stylesheets/other.css"]
          @another = ['/other_stylesheets/another.css', "/other_stylesheets/another.css"]
          @tags = []
          @opts[:href] = @def[1]
          @tags << tag(:link, @opts)
          @opts[:href] = @other[1]
          @tags << tag(:link, @opts)
          @opts[:href] = @another[1]
          @tags << tag(:link, @opts)
        end
        should "render if sheets passed as args" do
          assert_equal @tags.join("\n"), stylesheet_link_tag(@def[0], @other[0], @another[0])
        end
      end
    end
    
    context "'javascript_tag'" do
      should "render" do
        js = "alert('awesome');"
        assert_equal tag(:script, :type => 'text/javascript') { js }, javascript_tag { "alert('awesome');" }
      end
    end
    
    context "'javascript_include_tag'" do
      setup do
        @opts = {
          :type => "text/javascript"       
        }
        @def = ['default', "/javascripts/default.js"]
        @test = ['test', "/javascripts/test.js"]
        @def_dev_match = /default.js\?[0-9]+/
      end
      should "render a single source" do
        @opts[:src] = @def[1]
        assert_equal tag(:script, @opts) { '' }, javascript_include_tag('default')
      end
      should "render a development environment source" do
        assert_match @def_dev_match, javascript_include_tag('default', :environment => 'development')
      end
      context "with two stylsheets" do
        setup do
          @tags = []
          @opts[:src] = @def[1]
          @tags << tag(:script, @opts) { '' }
          @opts[:src] = @test[1]
          @tags << tag(:script, @opts) { '' }
        end
        should "render if sheets passed as args" do
          assert_equal @tags.join("\n"), javascript_include_tag(@def[0], @test[0])
        end
        should "render if sheets passed as an array" do
          assert_equal @tags.join("\n"), javascript_include_tag([@def[0], @test[0]])
        end
      end
      context "with three stylsheets referenced differently" do
        setup do
          @other = ['/other_javascripts/other', "/other_javascripts/other.js"]
          @another = ['/other_javascripts/another.js', "/other_javascripts/another.js"]
          @tags = []
          @opts[:src] = @def[1]
          @tags << tag(:script, @opts) { '' }
          @opts[:src] = @other[1]
          @tags << tag(:script, @opts) { '' }
          @opts[:src] = @another[1]
          @tags << tag(:script, @opts) { '' }
        end
        should "render if sheets passed as args" do
          assert_equal @tags.join("\n"), javascript_include_tag(@def[0], @other[0], @another[0])
        end
      end
    end
    
  end
  
end