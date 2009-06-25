require 'sinatra/base'
require File.join(File.dirname(__FILE__), 'helpers.rb')
require File.join(File.dirname(__FILE__), 'globals.rb')

module Useful
  module SinatraHelpers
    module Tags
      module Forms
        
        include Useful::SinatraHelpers::Tags::Helpers
        
        def form_tag(url, options={}, &block) 
          options.update :action => url
          tag(:form, options, &block)
        end
        
        def field_set_tag(legend=nil, options=nil, &block)
          content = "#{tag(:legend) { lengend.to_s } unless legend.nil?}#{sinatra_tag_helper_capture(&block)}"
          tag(:fieldset, options) { content }
        end
        
        def label_tag(name, value=nil, options={})
          value ||= name.to_s.capitalize
          options.update :for => name.to_s
          tag(:label, options) { value }
        end
        
        def hidden_field_tag(name, value=nil, options={}) 
          input_tag('hidden', name, value, options)
        end
        
        def password_field_tag(name="password", value=nil, options={}) 
          options[:disabled] = sinatra_tag_helper_disabled_option if options[:disabled]
          input_tag('password', name, value, options)
        end
        
        def file_field_tag(name, options={})
          options[:disabled] = sinatra_tag_helper_disabled_option if options[:disabled]
          input_tag('file', name, nil, options)
        end
        
       def check_box_tag(name, label=nil, value='1', checked=false, options={})
          options[:tag] ||= :div
          if options.has_key?(:class)
            options[:class] += ' checkbox'
          else
            options[:class] = 'checkbox'
          end
          options[:disabled] = sinatra_tag_helper_disabled_option if options[:disabled]
          options[:checked] = sinatra_tag_helper_checked_option if checked
          input_str = input_tag('checkbox', name, value, options)
          if label.nil?
            input_str
          else
            tag(options.delete(:tag), :class => 'checkbox') { input_str + label_tag(options[:id], label)  }
          end
        end
        
        def radio_button_tag(name, value, label, checked=false, options={}) 
          options[:tag] ||= :span
          if options.has_key?(:class)
            options[:class] += ' radiobutton'
          else
            options[:class] = 'radiobutton'
          end
          options[:disabled] = sinatra_tag_helper_disabled_option if options[:disabled]
          options[:checked] = sinatra_tag_helper_checked_option if checked
          input_str = input_tag('radio', name, value, options)
          if label.nil?
            input_str
          else
            label_tag(name, input_str + tag(options.delete(:tag)) { label }, :class => options.delete(:class))
          end
        end
        
        def select_tag(name, option_tags=nil, options={}) 
          options[:disabled] = sinatra_tag_helper_disabled_option if options[:disabled]
          html_name = (options[:multiple] == true && !name.to_s[(name.to_s.length-2)..-1] == "[]") ? "#{name}[]" : name
          options[:multiple] = sinatra_tag_helper_multiple_option if options[:multiple] == true
          input_tag('select', name, nil, options) { option_tags || '' }
        end

        def text_area_tag(name, content=nil, options={}) 
          options[:disabled] = sinatra_tag_helper_disabled_option if options[:disabled]
          options[:tag] = 'textarea'
          input_tag(nil, name, nil, options) { content || '' }
        end
        
        def text_field_tag(name, value=nil, options={}) 
          options[:disabled] = sinatra_tag_helper_disabled_option if options[:disabled]
          input_tag('text', name, value, options)
        end
        
        def submit_tag(value="Save", options={}) 
          options[:disabled] = sinatra_tag_helper_disabled_option if options[:disabled]
          input_tag('submit', 'commit', value, options)
        end
        
        def image_submit_tag(source, options={})
          options[:disabled] = sinatra_tag_helper_disabled_option if options[:disabled]
          options[:src] = source
          input_tag('image', nil, nil, options)
        end
        
      end
    end
  end
end

Sinatra::Application.helpers Useful::SinatraHelpers::Tags::Forms
