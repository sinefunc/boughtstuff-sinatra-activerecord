$LOAD_PATH.unshift(root_path('vendor', 'sinefunc', 'paperclip', 'lib'))
$LOAD_PATH.unshift(root_path('vendor', 'sinefunc', 'is_taggable', 'lib'))
$LOAD_PATH.unshift(root_path('vendor', 'sinefunc', 'will_paginate', 'lib'))

require 'paperclip'
require root_path('vendor/sinefunc/is_taggable/init')
require root_path('vendor/sinefunc/will_paginate/lib/will_paginate/finders/active_record')
