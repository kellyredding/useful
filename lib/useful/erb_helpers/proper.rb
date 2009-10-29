# Note: these helpers are designed to be actionpack safe
# => these helpers are included in the useful/rails_extensions/erb
# => don't put any actionpack helpers in this module

require 'useful/erb_helpers/common'
require 'useful/erb_helpers/tags'
require 'useful/ruby_extensions/string' unless ::String.new.respond_to?('ends_with?')
require 'useful/ruby_extensions/object' unless ::Object.new.respond_to?('true?')

module Useful; end
module Useful::ErbHelpers; end

module Useful::ErbHelpers::Proper
      
  include Useful::ErbHelpers::Common
  
  # This one's a little different than the corresponding actionpack version:
  # => ie. you don't pass an options string as the 2nd argument
  # => you, instead, pass a block that should return the desired options string
  # => ie, proper_select_tag('user') { '<option>test</option>' }
  def proper_select_tag(name, options={}, &block) 
    html_name = (options[:multiple].true? && !name.to_s.ends_with?("[]")) ? "#{name}[]" : name
    options[:multiple] = OPTIONS[:multiple] if options[:multiple] == true
    options[:tag] = 'select'
    input_tag(nil, html_name, nil, options, &block)
  end

  # TODO: proper_check_box_tag
  def check_box_tag(name, label=nil, value='1', checked=false, options={})
    tag_name = options.delete(:tag) || :div
    if options.has_key?(:class)
      options[:class] += ' checkbox'
    else
      options[:class] = 'checkbox'
    end
    options[:id] ||= erb_helper_common_safe_id(rand(1000).to_s)
    options[:checked] = OPTIONS[:checked] if checked
    input_str = input_tag('checkbox', name, value, options)
    if label.nil?
      input_str
    else
      tag(tag_name, :class => 'checkbox') { input_str + label_tag(options[:id], label)  }
    end
  end
  
  # TODO: proper_radio_button_tag
  def radio_button_tag(name, value, label=nil, checked=false, options={}) 
    tag_name = options.delete(:tag) || :span
    if options.has_key?(:class)
      options[:class] += ' radiobutton'
    else
      options[:class] = 'radiobutton'
    end
    label ||= value.to_s.capitalize
    options[:id] ||= erb_helper_common_safe_id(rand(1000).to_s)
    options[:checked] = OPTIONS[:checked] if checked
    input_str = input_tag('radio', name, value, options)
    if label.nil?
      input_str
    else
      label_tag(options[:id], input_str + tag(tag_name) { label }, :class => options.delete(:class))
    end
  end
  
  def self.included(receiver)
    receiver.send :include, Useful::ErbHelpers::Tags
  end
  
end
