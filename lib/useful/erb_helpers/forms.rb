require 'useful/erb_helpers/common'
require 'useful/erb_helpers/tags'

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
  
  def label_tag(name, value=nil, options={})
    value ||= name.to_s.capitalize
    options.update :for => name.to_s
    tag(:label, options) { value }
  end
  
  def input_tag(type, name, value, options={}, &block)
    options[:tag] ||= :input
    options[:type] = type unless type.nil?
    unless name.nil?
      options[:name] = name 
      options[:id] ||= erb_helper_common_safe_id(name)
    end
    options[:value] = value unless value.nil?
    tag(options.delete(:tag), options, &block)
  end

  def hidden_field_tag(name, value=nil, options={}) 
    input_tag('hidden', name, value, options)
  end
  
  def password_field_tag(name="password", value=nil, options={}) 
    options[:disabled] = OPTIONS[:disabled] if options[:disabled]
    input_tag('password', name, value, options)
  end
  
  def file_field_tag(name, options={})
    options[:disabled] = OPTIONS[:disabled] if options[:disabled]
    input_tag('file', name, nil, options)
  end
  
 def check_box_tag(name, label=nil, value='1', checked=false, options={})
    tag_name = options.delete(:tag) || :div
    if options.has_key?(:class)
      options[:class] += ' checkbox'
    else
      options[:class] = 'checkbox'
    end
    options[:id] ||= erb_helper_common_safe_id(rand(1000).to_s)
    options[:disabled] = OPTIONS[:disabled] if options[:disabled]
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
    options[:disabled] = OPTIONS[:disabled] if options[:disabled]
    options[:checked] = OPTIONS[:checked] if checked
    input_str = input_tag('radio', name, value, options)
    if label.nil?
      input_str
    else
      label_tag(options[:id], input_str + tag(tag_name) { label }, :class => options.delete(:class))
    end
  end
  
  def select_tag(name, options={}, &block) 
    options[:disabled] = OPTIONS[:disabled] if options[:disabled]
    html_name = (options[:multiple] == true && !name.to_s[(name.to_s.length-2)..-1] == "[]") ? "#{name}[]" : name
    options[:multiple] = OPTIONS[:multiple] if options[:multiple] == true
    options[:tag] = 'select'
    if block_given?
      @_out_buf ||= ''
      @_out_buf << input_tag(:select, html_name, nil, options) { erb_helper_common_capture(&block) }
    else
      input_tag(:select, html_name, nil, options)
    end
  end

  def text_area_tag(name, content=nil, options={}) 
    options[:disabled] = OPTIONS[:disabled] if options[:disabled]
    options[:tag] = 'textarea'
    input_tag(nil, name, nil, options) { content || '' }
  end
  
  def text_field_tag(name, value=nil, options={}) 
    options[:disabled] = OPTIONS[:disabled] if options[:disabled]
    input_tag('text', name, value, options)
  end
  
  def submit_tag(value="Save", options={}) 
    options[:disabled] = OPTIONS[:disabled] if options[:disabled]
    input_tag('submit', 'commit', value, options)
  end
  
  def image_submit_tag(source, options={})
    options[:disabled] = OPTIONS[:disabled] if options[:disabled]
    options[:src] = source
    options[:alt] ||= 'Save'
    input_tag('image', nil, nil, options)
  end
  
  def self.included(receiver)
    receiver.send :include, Useful::ErbHelpers::Tags
  end
  
end
