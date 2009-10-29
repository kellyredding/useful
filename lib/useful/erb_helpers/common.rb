module Useful; end
module Useful::ErbHelpers; end

module Useful::ErbHelpers::Common
  
  OPTIONS = {
    :disabled => 'disabled',
    :checked => 'checked',
    :multiple => 'multiple',
    :multipart => 'multipart/form-data'
  }.freeze
  
  protected
  
  def erb_helper_common_safe_id(id)
    id.gsub(/\[/, '_').gsub(/\]/, '').gsub(/\W/,'')
  end
  
  def erb_helper_common_capture(*args, &block)
    erb_helper_common_with_output_buffer { block.call(*args) }
  end
  
  def erb_helper_common_with_output_buffer(buf = '') #:nodoc:
    @_out_buf, old_buffer = buf, @_out_buf
    result = yield
    @_out_but.blank? ? result : @_out_buf
  ensure
    @_out_buf = old_buffer
  end
  
  def erb_helper_convert_options_to_javascript!(options)
    confirm, popup = options.delete(:confirm), options.delete(:popup)
    if confirm || popup
      options[:onclick] = case
        when confirm && popup
          "javascript: if (#{erb_helper_confirm_javascript(confirm)}) { #{erb_helper_popup_javascript(popup)} }; return false;"
        when confirm
          "javascript: return #{erb_helper_confirm_javascript(confirm)};"
        when popup
          "javascript: #{erb_helper_popup_javascript(popup)} return false;"
        else
          "javascript: return false;" # should never case to this b/c of if statement
      end
    end
  end

  def erb_helper_confirm_javascript(confirm)
    "confirm('#{escape_javascript(confirm)}')"
  end

  def erb_helper_popup_javascript(popup)
    popup.kind_of?(::Array) ? "window.open(this.href,'#{popup.first}','#{popup.last}');" : "window.open(this.href);"
  end

  def erb_helper_disable_with_javascript(disable_with)
    "javascript: this.disabled=true; this.value='#{escape_javascript(disable_with)}'; this.form.submit();"
  end

  JS_ESCAPE_MAP = {
    '\\'    => '\\\\',
    '</'    => '<\/',
    "\r\n"  => '\n',
    "\n"    => '\n',
    "\r"    => '\n',
    '"'     => '\\"',
    "'"     => "\\'" }

  # Escape carrier returns and single and double quotes for JavaScript segments.
  def escape_javascript(javascript)
    if javascript
      javascript.gsub(/(\\|<\/|\r\n|[\n\r"'])/) { JS_ESCAPE_MAP[$1] }
    else
      ''
    end
  end

end      
