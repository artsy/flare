# 
# Because Zepto's authors don't like to advance the future of the web and
# support any module definitions or package managers we have to point the package.json
# to their git repo and stitch together the Zepto modules in this wrapper.
# 
# This allows us to include touch.js and other zepto modules that aren't included
# in the unsupported package managers Zepto seems to be hosted on like Bower or npm.
# 

# Explicitly create a `Zepto` global for server-side support
require '../../node_modules/zepto/src/zepto.js'
global?.Zepto = global?.$ = window.Zepto

# Attach Zepto modules
require '../../node_modules/zepto/src/event.js'
require '../../node_modules/zepto/src/detect.js'
require '../../node_modules/zepto/src/fx.js'
require '../../node_modules/zepto/src/ajax.js'
require '../../node_modules/zepto/src/form.js'
require '../../node_modules/zepto/src/touch.js'

# Attach plugins
require './remove_column_space.coffee'
require './infinite_scroll.coffee'

# Export Zepto
module.exports = Zepto