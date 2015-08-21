'use strict'

async     = require('async')
fs        = require('fs')
path      = require('path')
Manifest  = require('./manifest')
mixin     = require('./mixin')


# Psuedocode
# ------------------------------
# - Detect directory
# - Detect manifest
# - Detect videos

class Check

  constructor : ->

  run  : (name) ->
    (callback) =>
      async.series [
        @_checkDirectory(name)
        @_checkManifest(name)
        @_checkVideos(name)
      ], callback


  _checkDirectory : (name) ->
    (callback) ->
      mixin.write 'blue', '\nChecking directory...'
      directory = "#{process.cwd()}/#{name}"
      #
      # Create directory
      #
      if not fs.existsSync(directory)
        mixin.write 'red', '\nDirectory do not exist.'
        mixin.write 'blue', '\nCreating directory....'
        fs.mkdir "#{directory}", '0777', (err) ->
          mixin.write 'green', '\nError while creating directory!' if err
          mixin.write 'green', '\nCreating directory : done'
          callback null, {}
      else
        mixin.write 'green', "\nChecking directory : done"
        callback null, {}

  _checkManifest : (name) ->
    (callback) ->
      mixin.write 'blue', '\nChecking `manifest.json`...'
      directory = "#{process.cwd()}/#{name}"
      #
      # Create manifest
      #
      if not fs.existsSync("#{directory}/manifest.json")
        mixin.write 'red', '\nManifest do not exist.'
        manifest = new Manifest()
        manifest.create(name, 1) callback

      else
        mixin.write 'green', '\nChecking `manifest.json` : done'
        callback null, {}


  _checkVideos : ->
    (callback) ->
      # Update status when video exist and match id
      mixin.write 'blue', '\nChecking videos...'
      mixin.write 'green', '\nChecking videos : done'
      callback null, {}



module.exports = Check