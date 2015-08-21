'use strict'

async     = require('async')
fs        = require('fs')
path      = require('path')
chalk     = require('chalk')
Manifest  = require('./manifest')


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
      process.stdout.write chalk.blue "\nChecking directory..."
      directory = "#{process.cwd()}/#{name}"
      #
      # Create directory
      #
      if not fs.existsSync(directory)
        process.stdout.write chalk.red "\nDirectory do not exist."
        process.stdout.write chalk.blue "\nCreating directory...."
        fs.mkdir "#{directory}", '0777', (err) ->
          process.stdout.write chalk.green "\nError while creating directory!" if err
          process.stdout.write chalk.green "\nCreating directory : done"
          callback null, {}
      else
        process.stdout.write chalk.green "\nChecking directory : done"
        callback null, {}

  _checkManifest : (name) ->
    (callback) ->
      process.stdout.write chalk.blue "\nChecking `manifest.json`..."
      directory = "#{process.cwd()}/#{name}"
      #
      # Create manifest
      #
      if not fs.existsSync("#{directory}/manifest.json")
        process.stdout.write chalk.red "\nManifest do not exist."
        manifest = new Manifest()
        manifest.create(name, 1) callback

      else
        process.stdout.write chalk.green "\nChecking `manifest.json` : done"
        callback null, {}


  _checkVideos : ->
    (callback) ->
      # Update status when video exist and match id
      process.stdout.write chalk.blue "\nChecking videos..."
      process.stdout.write chalk.green "\nChecking videos : done"
      callback null, {}



module.exports = Check