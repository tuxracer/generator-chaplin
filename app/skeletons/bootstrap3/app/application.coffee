# Underscore String
_ = require 'lodash' # Import Underscore
_.str = require 'underscore.string' # Import Underscore.string to separate object, because there are conflict functions (include, reverse, contains)

# Fix to ensure Chaplin's instance of Backbone has jQuery
$ = require 'jquery'
Backbone = require 'backbone'
Backbone.$ = $

Chaplin = require 'chaplin'

module.exports = class Application extends Chaplin.Application
