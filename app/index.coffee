path = require 'path'
yeoman = require 'yeoman-generator'
fs = require 'fs'
util = require 'util'
glob = require 'glob'

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
      spath = '../skeletons/bootstrap3'
      @template "#{spath}/_bower.json", 'bower.json'
      @copy "#{spath}/app/assets/index.hbs", 'app/assets/index.hbs'
      @copy "#{spath}/Gruntfile.coffee", 'Gruntfile.coffee'
      @template "#{spath}/app/_initialize.coffee", 'app/initialize.coffee'
      @copy "#{spath}/app/application.coffee", 'app/application.coffee'
      @copy "#{spath}/app/mediator.coffee", 'app/mediator.coffee'
      @copy "#{spath}/app/routes.coffee", 'app/routes.coffee'
      @copy "#{spath}/app/controllers/_home.coffee", "app/controllers/home#{@controllerSuffix}.coffee"
      @copy "#{spath}/app/styles/application.styl", 'app/styles/application.styl'
      @copy "#{spath}/app/styles/base.styl", 'app/styles/base.styl'
      @copy "#{spath}/app/styles/modules/footer.styl", 'app/styles/modules/footer.styl'
      @copy "#{spath}/app/templates/footer.hbs", 'app/templates/footer.hbs'
      @copy "#{spath}/app/templates/header.hbs", 'app/templates/header.hbs'
      @copy "#{spath}/app/templates/home.hbs", 'app/templates/home.hbs'
      @copy "#{spath}/app/templates/jumbotron.hbs", 'app/templates/jumbotron.hbs'
      @copy "#{spath}/app/templates/site.hbs", 'app/templates/site.hbs'
      @copy "#{spath}/app/views/bootstrap/jumbotron.coffee", 'app/views/bootstrap/jumbotron.coffee'
      @copy "#{spath}/app/views/footer.coffee", 'app/views/footer.coffee'
      @copy "#{spath}/app/views/header.coffee", 'app/views/header.coffee'
      @copy "#{spath}/app/views/home/home-page.coffee", 'app/views/home/home-page.coffee'
      @copy "#{spath}/app/views/site-view.coffee", 'app/views/site-view.coffee'

      glob.sync("#{__dirname}/templates/app/**/*")
      .map (file) ->
        path.resolve file
      .forEach (file) =>
        if fs.statSync(file).isFile() and not file.match /^_/
          file = file.replace "#{__dirname}/templates/", ''
          @copy file, file
