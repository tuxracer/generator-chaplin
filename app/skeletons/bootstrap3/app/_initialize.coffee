Application = require './application'
routes = require './routes'

$ ->
  new Application {
    title: '<%= appName %>',
    controllerSuffix: '-controller',
    routes
  }
