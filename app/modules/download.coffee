'use strict'

_           = require('lodash')
async       = require('async')
request     = require('superagent')
ProgressBar = require('progress')
chalk       = require('chalk')
fs          = require('fs')
mixin       = require('./mixin')

class Download

  constructor : ->

  run : (name) ->
    (callback) =>
      async.waterfall [
        @_getId(name)
        @_getVimeoPage()
        @_getRequestFiles()
        @_downloadVideo(name)
      ], (err, result) ->
        callback err, result

  _getId : (name) ->
    (callback) ->
      file      = "#{process.cwd()}/#{name}/manifest.json"
      manifest  = require(file)
      created   = _.find(manifest, { 'status': 'created'})
      mixin.write 'cyan', "\n------------------"
      mixin.write 'cyan', "\nId \t\t: #{created.id}"
      mixin.write 'cyan', "\nName \t\t: #{created.name}"

      callback null, created?.id

  _getVimeoPage : ->
    (input, callback) ->
      id = input
      request
      .get("https://player.vimeo.com/video/#{id}")
      .end  (err, result) ->
        callback null, result.text

  _getRequestFiles :  ->
    (input, callback) ->
      html        = input
      regex_a     = /t={(.*)};if/
      regex_b     = /{(.*)}/
      string      = html?.match(regex_a)
      string      = string[0]?.match(regex_b)
      object      = JSON.parse(string[0])
      callback null, object?.request?.files

  _downloadVideo : (name) ->
    (input, callback) ->
      files = input
      url   = files?.h264?.hd?.url
      mixin.write 'cyan', "\nUrl \t\t: #{url}"

      request
        .get(url)
        .parse (res, callback) ->

          params        =
            complete    : '='
            incomplete  : ' '
            width       : 20
            total       : parseInt(res.headers['content-length'], 10)
          bar           = new ProgressBar 'Downloading \t: [:bar] :percent :etas', params
          data = []
          res.on 'data', (chunk) ->
            bar.tick(chunk.length)
            data.push chunk

          res.on 'end',  ->
            console.log 'end'
            # callback(null, new Buffer(data, 'binary'))
            fs.writeFile "#{process.cwd()}/#{name}/__ralph.mp4", new Buffer(data), (err) ->
              console.log 'err'


      # output = fs.createWriteStream("#{process.cwd()}/#{name}/__ralph.mp4");
          # res.pipe(output)

        .end  (err, result) ->
          console.log 'result?.body', result?.body
          callback err, result


#        .



module.exports = Download