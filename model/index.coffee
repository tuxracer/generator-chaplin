yeoman = require 'yeoman-generator'
helpers = require __dirname + '/../lib'

module.exports = class ModelGenerator extends yeoman.generators.NamedBase
  constructor: ->
    yeoman.generators.NamedBase.apply @, arguments
    helpers.generators.nameAndPath.call @

  files: ->
    helpers.creators.nameAndPath.call @, 'model'
