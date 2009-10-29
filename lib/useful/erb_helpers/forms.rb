require 'useful/erb_helpers/common'
require 'useful/erb_helpers/tags'
require 'useful/ruby_extensions/string' unless ::String.new.respond_to?('humanize') && ::String.new.respond_to?('ends_with?')
require 'useful/ruby_extensions/object' unless ::Object.new.respond_to?('true?')

module Useful; end
module Useful::ErbHelpers; end

module Useful::ErbHelpers::Forms
      
  include Useful::ErbHelpers::Common
  
  def form_tag(url, options={}, &block) 
    options[:method] = 'post' unless ['get','post','put','delete'].include?(options[:method])
    options.update :action => url
    if multipart = options.delete(:multipart)
      options[:enctype] = OPTIONS[:multipart]
    end
    if block_given?
      @_out_buf ||= ''
      @_out_buf << tag(:form, options) { erb_helper_common_capture(&block) }
    else
      tag(:form, options)
    end
  end
  
  def field_set_tag(legend=nil, options={}, &block)
    legend_html = legend.nil? ? '' : tag(:legend) { legend.to_s }
    if block_given?
      @_out_buf ||= ''
      @_out_buf << tag(:fieldset, options) { legend_html + erb_helper_common_capture(&block) }
    else
      tag(:fieldset, options) { legend_html }
    end
  end
  
  def input_tag(type, name, value=nil, options={}, &block)
    options[:tag] ||= :input
    options[:type] = type unless type.nil?
    unless name.nil?
      options[:name] = name 
      options[:id] ||= erb_helper_common_safe_id(name)
    end
    options[:value] = value unless value.nil?
    options[:disabled] = OPTIONS[:disabled] if options[:disabled]
    if block_given?
      @_out_buf ||= ''
      @_out_buf << tag(options.delete(:tag), options) { erb_helper_common_capture(&block) }
    else
      tag(options.delete(:tag), options)
    end
  end

  def label_tag(name, value=nil, options={})
    value ||= name.to_s.gsub(/\[/, '_').gsub(/\]/, '').humanize
    options[:for] ||= erb_helper_common_safe_id(name)
    tag(:label, options) { value }
  end
  
  def hidden_field_tag(name, value=nil, options={}) 
    input_tag('hidden', name, value, options)
  end
  
  def text_field_tag(name, value=nil, options={}) 
    input_tag('text', name, value, options)
  end
  
  def password_field_tag(name="password", value=nil, options={}) 
    input_tag('password', name, value, options)
  end
  
  def file_field_tag(name, options={})
    input_tag('file', name, nil, options)
  end
  
  # Special options:
  # => :disable_with - string
  #   => will add js onclick event to first disable submit, setting text to value, and then submitting form
  # => :confirm - string
  #   => will add js confirm confirmation before submitting
  def submit_tag(value=OPTIONS[:default_submit_value], options={})
    options[:onclick] = erb_helper_disable_with_javascript(options.delete(:disabled_with)) if options.has_key?(:disabled_with)
    if options.has_key?(:confirm)
      options[:onclick] ||= 'return true;'
      options[:onclick] = "if (!#{erb_helper_confirm_javascript(options.delete(:confirm))}) return false; #{options[:onclick]}"
    end
    input_tag('submit', 'commit', value, options)
  end
  
  # Special options:
  # => :confirm - string
  #   => will add js confirm confirmation before submitting
  def image_submit_tag(source, options={})
    options[:src] = ['/'].include?(source[0..0]) ? source : "/images/#{source}"
    options[:alt] ||= OPTIONS[:default_submit_value]
    if options.has_key?(:confirm)
      options[:onclick] ||= 'return true;'
      options[:onclick] = "if (!#{erb_helper_confirm_javascript(options.delete(:confirm))}) return false; #{options[:onclick]}"
    end
    input_tag('image', nil, nil, options)
  end
  
  # Special options:
  # => :size - A string specifying the dimensions (columns by rows) of the textarea (e.g., "25x10").
  # => :rows - Specify the number of rows in the textarea
  # => :cols - Specify the number of columns in the textarea
  # => :escape - By default, the contents of the text input are HTML escaped. If you need unescaped contents, set this to false.
  def text_area_tag(name, content=nil, options={}) 
    options[:tag] = 'textarea'
    if size = options.delete(:size)
      options[:cols], options[:rows] = size.split("x") if size.respond_to?(:split)
    end
    unless options.has_key?(:escape) && options.delete(:escape).false?
      content = escape_html(content)
    end
    input_tag(nil, name, nil, options) { content || '' }
  end
  
  # This one's a little different than the corresponding active support version:
  # => ie. you don't pass an options string as the 2nd argument
  # => you, instead, pass a block that should return the desired options string
  # => ie, select_tag('user') { '<option>test</option>' }
  def select_tag(name, options={}, &block) 
    html_name = (options[:multiple].true? && !name.to_s.ends_with?("[]")) ? "#{name}[]" : name
    options[:multiple] = OPTIONS[:multiple] if options[:multiple] == true
    options[:tag] = 'select'
    input_tag(nil, html_name, nil, options, &block)
  end

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
