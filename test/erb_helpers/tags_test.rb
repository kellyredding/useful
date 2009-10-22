require File.dirname(__FILE__) + '/../test_helper'

class TagsTest < Test::Unit::TestCase
  
  include Useful::ErbHelpers::Tags

  context "the erb" do

    context "'h_text' helper" do
      context "given text" do
        setup { @text = "Some boring plain text" }
        should "return the text" do
          assert_equal @text, h_text(@text)
        end
        context "with html markup" do
          setup { @text += " <strong>with pizazz</strong>" }
          should "return the text with the html escaped" do
            assert_equal h(@text), h_text(@text)
          end
        end
        context "with line breaks" do
          setup { @l1 = "Here is a line break" }
          should "return the text with line break markup" do
            assert_equal "#{@text}<br />#{@l1}", h_text(@text+"\n"+@l1)
          end
          context "and leading white space" do
            setup { @l2 = "Here is a line break with leading white space" }
            should "return the text with line break and whitespace markup" do
              assert_equal "#{@text}<br />#{@l1}<br />&nbsp;&nbsp;#{@l2}", h_text(@text+"\n"+@l1+"\n  "+@l2)
            end
          end
        end
      end
    end

    context "'tag' helper" do
      should "provide html for the tag" do
        assert_equal "<br />", tag(:br)
      end     
      context "with options" do
        setup { @options = {:class => 'big', :id => '1234'} }
        should "provide html for the tag" do
          assert_equal "<br #{@options.to_html_attrs} />", tag(:br, @options)
        end
        context "and content" do
          setup { @content = "Loud Noises" }
          should "provide html for the tag" do
            assert_equal "<strong #{@options.to_html_attrs}>#{@content}</strong>", tag(:strong, @options) { @content }
          end
        end
      end
    end

    context "'clear_tag' helper" do
      should "provide html for a clearing tag" do
        assert_equal "<div #{{:style => 'clear:both;'}.to_html_attrs}></div>", clear_tag
      end     
      context "with a specified tag" do
        setup { @tag = :span }
        should "provide html for a clearing tag" do
          assert_equal "<span #{{:style => 'clear:both;'}.to_html_attrs}></span>", clear_tag(:tag => @tag)
        end     
      end
      context "with specified style" do
        setup { @style = "font-weight:bold; color:red" }
        should "provide html for a clearing tag" do
          assert_equal "<div #{{:style => ('clear:both; '+@style)}.to_html_attrs}></div>", clear_tag(:style => @style)
        end     
      end
    end

  end
  
end