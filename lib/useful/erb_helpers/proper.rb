# Note: these helpers are designed to be actionpack safe
# => these helpers are included in the useful/rails_extensions/erb
# => don't put any actionpack helpers in this module

require 'useful/erb_helpers/common'
require 'useful/erb_helpers/tags'
require 'useful/ruby_extensions/string' unless ::String.new.respond_to?('ends_with?')
unless ::Object.new.respond_to?('blank?') && ::Object.new.respond_to?('is_true?') && ::Object.new.respond_to?('returning')
  require 'useful/ruby_extensions/object'
end

module Useful; end
module Useful::ErbHelpers; end

module Useful::ErbHelpers::Proper
      
  include Useful::ErbHelpers::Common
  
  # This one's a little different than the corresponding actionpack version:
  # => ie. you don't pass an options string as the 2nd argument
  # => you, instead, pass a block that should return the desired options string
  # => ie, proper_select_tag('user') { '<option>test</option>' }
  def proper_select_tag(name, options={}, &block) 
    html_name = (options[:multiple].is_true? && !name.to_s.ends_with?("[]")) ? "#{name}[]" : name
    options[:multiple] = OPTIONS[:multiple] if options[:multiple] == true
    options[:tag] = 'select'
    input_tag(nil, html_name, nil, options, &block)
  end

  # TODO: write tests
  def proper_check_box_tag(*args)
    name, value, checked, options = proper_check_radio_options('1', args)
    options[:id] ||= erb_helper_common_safe_id(name.to_s)
    options[:checked] = OPTIONS[:checked] if checked
    label_text = options.delete(:label)
    unchecked_value = options.delete(:unchecked_value)
    unchecked_value = '0' if unchecked_value.nil?
    disable_unchecked_value = options.delete(:disable_unchecked_value)
    returning html = '' do
      html << input_tag(:hidden, name, unchecked_value, :id => "#{options[:id]}_hidden") unless disable_unchecked_value.is_true?
      html << input_tag(:checkbox, name, value, options)
      html << tag(:label, :for => options[:id]) { label_text } unless label_text.blank?
    end
  end
  
  # TODO: write tests
  def proper_radio_button_tag(*args)
    name, value, checked, options = proper_check_radio_options(nil, args)
    options[:id] ||= erb_helper_common_safe_id(name.to_s)
    options[:checked] = OPTIONS[:checked] if checked
    label_text = options.delete(:label) || value.to_s.humanize
    label_container_tag = options.delete(:tag) || :span
    radio_button_str = input_tag(:radio, name, value, options)
    returning html = '' do
      html << if label_text.blank?
        radio_button_str
      else
        tag(:label, :for => options[:id]) do
          radio_button_str + tag(label_container_tag) { label_text }
        end
      end
    end
  end

  def self.included(receiver)
    receiver.send :include, Useful::ErbHelpers::Tags
  end
  
  private
  
  def proper_check_radio_options(default_value, args)
    # args should be passed to proper checkbox and radiobutton tags like this:
    # => name, value, checked, options={}
    # this allows user to pass only args they care about,
    # and default the ones they don't care about
    if case_arg_options_for_length(4, args)
      # args: name, value, checked, options --OR-- name, value, checked
      args[1] ||= default_value # default the value
      args[2] ||= false         # default whether checked
      args[3] ||= {}            # default the options
      [args[0], args[1], args[2], args[3]]
    elsif case_arg_options_for_length(3, args)
      # args: name, value, options --OR-- name, value
      args[1] ||= default_value # default the value
      args[2] ||= {}            # default the options
      checked = (args[2].delete(:checked) || false) rescue false
      [args[0], args[1], checked, args[2]]
    elsif case_arg_options_for_length(2, args)
      # args: name, options --OR-- name
      args[1] ||= {}            # default the options
      value = (args[1].delete(:value) || default_value) rescue default_value
      checked = (args[1].delete(:checked) || false)  rescue false
      [args[0], value, checked, args[1]]
    elsif case_arg_options_for_length(1, args)
      # args: name
      # => default everything
      [args[0], default_value, false, {}]
    else
      # this is invalid
      raise ArgumentError, "please specify 1 to 4 arguments for name, value, checked, and options"
    end
  end
  
  def case_arg_options_for_length(length, args)
    args.length == length || (args.length == (length-1) && !(args[(length-2)].kind_of?(::Hash) || args[(length-2)].nil?))
  end

end
