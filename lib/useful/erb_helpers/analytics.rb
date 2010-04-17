require 'useful/erb_helpers/common'

module Useful; end
module Useful::ErbHelpers; end

module Useful::ErbHelpers::Analytics
      
  include Useful::ErbHelpers::Common
  
  # Use the keyed google analytics account
  def google_analytics(key)
    %{
      <script type="text/javascript">
        var _gaq = _gaq || [];
        _gaq.push(['_setAccount', '#{key}']);
        _gaq.push(['_trackPageview']);

        (function() {
        var ga = document.createElement('script');
        ga.src = ('https:' == document.location.protocol ?
            'https://ssl' : 'http://www') +
            '.google-analytics.com/ga.js';
        ga.setAttribute('async', 'true');
        document.documentElement.firstChild.appendChild(ga);
        })();
      </script>
    } if production?
  end
  
end
