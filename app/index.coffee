path = require 'path'
yeoman = require 'yeoman-generator'
fs = require 'fs'
util = require 'util'
glob = require 'glob'

isTemplate = (filepath) ->
  path
  .basename(filepath)
  .match(/^_/)

# Converts foo/bar/_blah.txt to foo/bar/blah.txt
getDest = (filepath) ->
  filepath = filepath
  .replace(__dirname, '')
  .replace('skeletons/bootstrap3/', '')
  .replace(/^\/templates/, '')
  .substr(1)

  filename = if isTemplate(filepath) then path.basename(filepath).substr(1) else path.basename(filepath)

  filedir = path
  .dirname(filepath)

  path.join filedir, filename

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
    ]
    @prompt prompts, (props) ->
      @appName = props.appName
      cb()

  app: ->
    unless @exists
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

      @copy 'server.coffee', 'server.coffee'

      glob.sync("#{__dirname}/**/*")
      .map (file) ->
        file = path.resolve file
      .filter (file) ->
        basename = path.basename(file)
        fs.statSync(file).isFile() and basename isnt 'index.coffee' and basename isnt 'index.js'
      .forEach (file) =>
        dest = getDest file
        method = if isTemplate(file) then 'template' else 'copy'

        @[method] file, dest
