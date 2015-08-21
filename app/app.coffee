'use strict'

async       = require('async')
commander   = require('commander')
path        = require('path')
rootPath    = path.normalize(__dirname + '/..')
dotenv      = require('dotenv')
dotenv.config({path:"#{rootPath}/env/#{process.env.NODE_ENV}"})
Check       = require('./modules/check')


# Psuedocode
# ------------------------------
# - Detect directory
# - Detect manifest
# - Detect videos

class App

  constructor : (name) ->
    check =  new Check()
    async.series [
      check.run(name)
    ], (err, result) ->



module.exports = App