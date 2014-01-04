yeoman = require 'yeoman-generator'
helpers = require __dirname + '/../lib'

module.exports = class ControllerGenerator extends yeoman.generators.NamedBase
  constructor: ->
    yeoman.generators.NamedBase.apply @, arguments
    helpers.generators.nameAndPath.call @

  files: ->
    helpers.creators.nameAndPath.call @, 'controller'
