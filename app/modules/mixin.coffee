'use strict'

chalk   = require('chalk')
mixin   =

  write : (color = 'blue', message) ->
    return false if process.env.NODE_ENV is 'test'
    process.stdout.write chalk[color] message

module.exports = mixin