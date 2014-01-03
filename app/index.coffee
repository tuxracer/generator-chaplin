path = require 'path'
yeoman = require 'yeoman-generator'
fs = require 'fs'
util = require 'util'
walk = require "#{__dirname}/lib/walk"

module.exports = class ChaplinGenerator extends yeoman.generators.Base
  constructor: (args, options, config) ->
    yeoman.generators.Base.apply this, arguments
    @exists = false
    @on 'end', ->
      @installDependencies skipInstall: options['skip-install'] unless @exists

    @pkg = JSON.parse @readFileAsString path.join __dirname, '../package.json'

  askFor: ->
    cb = @async()

    # have Yeoman greet the user.
    console.log @yeoman
    prompts = [
      name: 'appName'
      message: 'Application name'
    ,
      name: 'controllerSuffix'
      message: 'Controller suffix (leave this blank if you dont want one)'
    ]
    @prompt prompts, (props) =>
      @appName = props.appName
      if typeof props.controllerSuffix is 'string' and props.controllerSuffix.length > 0
        @controllerSuffix = props.controllerSuffix
      else
        @controllerSuffix = ''
      cb()

  app: ->
    unless @exists
      cb = @async()
      @copy 'editorconfig', '.editorconfig'
      @copy 'jshintrc', '.jshintrc'
      @mkdir 'app'
      @mkdir 'app/assets'
      @mkdir 'app/assets/fonts'
      @mkdir 'app/assets/img'
      @mkdir 'app/controllers'
      @mkdir 'app/lib'
      @mkdir 'app/models'
      @mkdir 'app/styles'
      @mkdir 'app/templates'
      @mkdir 'app/views'
      @mkdir 'test'
      @mkdir 'vendor'
      @template '_config.json', 'config.json'
      @template '_package.json', 'package.json'
      @copy 'server.coffee', 'server.coffee'
      path = '../skeletons/bootstrap3'
      @template "#{path}/_bower.json", 'bower.json'
      @copy "#{path}/app/assets/index.hbs", 'app/assets/index.hbs'
      @copy "#{path}/Gruntfile.coffee", 'Gruntfile.coffee'
      @template "#{path}/app/_initialize.coffee", 'app/initialize.coffee'
      @copy "#{path}/app/application.coffee", 'app/application.coffee'
      @copy "#{path}/app/mediator.coffee", 'app/mediator.coffee'
      @copy "#{path}/app/routes.coffee", 'app/routes.coffee'
      @copy "#{path}/app/controllers/_home.coffee", "app/controllers/home#{@controllerSuffix}.coffee"
      @copy "#{path}/app/styles/application.styl", 'app/styles/application.styl'
      @copy "#{path}/app/templates/footer.hbs", 'app/templates/footer.hbs'
      @copy "#{path}/app/templates/header.hbs", 'app/templates/header.hbs'
      @copy "#{path}/app/templates/home.hbs", 'app/templates/home.hbs'
      @copy "#{path}/app/templates/jumbotron.hbs", 'app/templates/jumbotron.hbs'
      @copy "#{path}/app/templates/site.hbs", 'app/templates/site.hbs'
      @copy "#{path}/app/views/bootstrap/jumbotron.coffee", 'app/views/bootstrap/jumbotron.coffee'
      @copy "#{path}/app/views/footer.coffee", 'app/views/footer.coffee'
      @copy "#{path}/app/views/header.coffee", 'app/views/header.coffee'
      @copy "#{path}/app/views/home/home-page.coffee", 'app/views/home/home-page.coffee'
      @copy "#{path}/app/views/site-view.coffee", 'app/views/site-view.coffee'

      # Ignore .DS_Store files as well as files that start with _.
      walk "#{__dirname}/templates/app", (err, files) =>
        throw err  if err
        files.forEach (file) =>
          if file.indexOf('.DS_Store') is -1 and file.indexOf('_') isnt 0
            file = file.replace "#{__dirname}/templates/", ''
            @copy file, file

        cb()
