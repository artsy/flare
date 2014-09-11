require('backbone').$ = $
$ ->
  require('../components/layout/bootstrap.coffee')()
  require('../apps/home/client/view.coffee').init()
