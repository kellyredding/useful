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
          input_tag(name, 'hidden', value, options)
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
          input_str = input_tag(name, 'checkbox', value, options)
          if label.nil?
            input_str
          else
            tag(options.delete(:tag), :class => 'checkbox') { input_str + label_tag(options[:id], label)  }
          end
        end
        
        def file_field_tag(name, options={})
          options[:disabled] = sinatra_tag_helper_disabled_option if options[:disabled]
          input_tag(name, 'file', nil, options)
        end
        
        def image_submit_tag(source, options={})
          options[:disabled] = sinatra_tag_helper_disabled_option if options[:disabled]
        end

      end
    end
  end
end

Sinatra::Application.helpers Useful::SinatraHelpers::Tags::Forms
