$LOAD_PATH.unshift(root_path('vendor', 'sinefunc', 'is_taggable', 'lib'))
$LOAD_PATH.unshift(root_path('vendor', 'sinefunc', 'will_paginate', 'lib'))

require root_path('vendor/sinefunc/is_taggable/init')
require root_path('vendor/sinefunc/will_paginate/lib/will_paginate/finders/active_record')
require root_path('vendor/sinefunc/will_paginate/lib/will_paginate/view_helpers/base')
require root_path('vendor/sinefunc/will_paginate/lib/will_paginate/view_helpers/link_renderer')

ActiveRecord::Base.extend WillPaginate::Finders::ActiveRecord
ActiveRecord::Base.per_page = 15

WillPaginate::ViewHelpers::LinkRenderer.class_eval do
  protected
  def url(page)
    url = @template.request.url
    if page == 1
      # strip out page param and trailing ? if it exists
      url.gsub(/page=[0-9]+/, '').gsub(/\?$/, '')
    else
      if url =~ /page=[0-9]+/
        url.gsub(/page=[0-9]+/, "page=#{page}")
      else
        url + "?page=#{page}"
      end      
    end
  end
end

