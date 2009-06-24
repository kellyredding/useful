module Useful
  module SinatraHelpers
    module Tags
      module Helpers
        
        def sinatra_tag_helper_safe_id(id)
          id.gsub(/\W/,'')
        end
        
        def sinatra_tag_helper_capture(*args, &block)
          block.call(*args)
        end
        
        def sinatra_tag_helper_disabled_option
          'disabled' 
        end
        
        def sinatra_tag_helper_checked_option
          'checked'
        end
        
        def sinatra_tag_helper_hash_to_html_attrs(a_hash)
          a_hash.collect{|key, val| "#{key}=\"#{val}\""}.join(' ')
        end

      end      
    end
  end
end
