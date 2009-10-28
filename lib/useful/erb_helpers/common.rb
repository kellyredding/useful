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
    id.gsub(/\W/,'')
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
  
end      
