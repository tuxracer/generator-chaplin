yeoman = require 'yeoman-generator'
helpers = require __dirname + '/../lib'

module.exports = class CollectionGenerator extends yeoman.generators.NamedBase
  constructor: ->
    yeoman.generators.NamedBase.apply @, arguments
    helpers.generators.nameAndPath.call @

  files: ->
    helpers.creators.nameAndPath.call @, 'collection'
