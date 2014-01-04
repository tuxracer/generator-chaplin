Controller = require './base/controller'
FooterView = require '../views/footer-view'
HeaderView = require '../views/header-view'
HomePageView = require '../views/home/home-page-view'
JumbotronView = require '../views/bootstrap/jumbotron-view'

module.exports = class HomeController extends Controller

  beforeAction: ->
    super

    @compose 'header', HeaderView, region: 'header'
    @compose 'footer', FooterView, region: 'footer'

  index: ->
    @view = new JumbotronView region: 'main'
    @view.subview 'home-page-content', new HomePageView region: 'main'

    @
