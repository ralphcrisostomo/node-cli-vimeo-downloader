'use strict'

Check       = require('./modules/check')
Download    = require('./modules/download')
async       = require('async')
commander   = require('commander')
path        = require('path')
rootPath    = path.normalize(__dirname + '/..')
dotenv      = require('dotenv')
dotenv.config({path:"#{rootPath}/env/#{process.env.NODE_ENV}"})



# Psuedocode
# ------------------------------
# - Detect directory
# - Detect manifest
# - Detect videos

class App

  constructor : (name) ->
    check     = new Check()
    download  = new Download()
    async.series [
      check.run(name)
      download.run(name)
    ], (err, result) ->



module.exports = App