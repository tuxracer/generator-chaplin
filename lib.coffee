_ = require 'lodash'
fs = require 'fs'
exec = require('child_process').exec

module.exports = helpers =
  capitalize: (string) ->
    string.charAt(0).toUpperCase() + string.slice(1)

  creators:
    nameAndPath: (type) ->
      name = helpers.slugify(@name)

      switch type
        when 'collection'
          pathType = 'model'
        when 'view'
          pathType = 'collectionview'
        else
          pathType = type

      if @path
        if type is 'template'
          @copy 'index.hbs', "app/templates/#{@path}/#{name}.hbs"
        else
          @template "_#{type}.coffee", "app/#{pathType}s/#{@path}/#{name}.coffee"
      else
        if type is 'template'
          @copy 'index.hbs', "app/templates/#{name}.hbs"
        else
          @template "_#{type}.coffee", "app/#{pathType}s/#{name}.coffee"

  generators:
    nameAndPath: ->
      if @name.indexOf('/') > -1
        s = @name.lastIndexOf('/')
        p = @name.substring(0, s)
        n = @name.split('/').pop()
        @name = n
        @path = p
      else
        @path = null

  deleteCurrentFolder: ->
    currentFolder = process.cwd().split('/').pop()
    exec "rm -rf #{process.cwd()}/*"

  slugify: (str) ->
    str = str.replace(/^\s+|\s+$/g, '') # trim
    str = str.toLowerCase()
    from = 'àáäâèéëêìíïîòóöôùúüûñç·/_,:;'
    to = 'aaaaeeeeiiiioooouuuunc------'
    i = 0
    l = from.length

    while i < l
      str = str.replace(new RegExp(from.charAt(i), 'g'), to.charAt(i))
      i++
    str = str.replace(/[^a-z0-9 -]/g, '').replace(/\s+/g, '-').replace(/-+/g, '-')
    str
