bootstrap = require '../../../components/layout/bootstrap.coffee'
HomePageView = require './view.coffee'
redirectIphone = require '../../../lib/redirect_iphone.coffee'

$ ->
  bootstrap()
  redirectIphone()
  new HomePageView
