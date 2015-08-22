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
    @retry = 0

  run : (name) ->
    (callback) =>
      async.waterfall [
        @_getId(name)
        @_getVimeoPage()
        @_getRequestFiles()
        @_downloadVideo(name)
        @_updateManifest(name)
      ], (err, result) =>
        if err is 'retry'
          mixin.write 'red', "\n------------------"
          mixin.write 'red', "\nRetrying... (#{@retry})"
          @run(name) callback
        else if err is 'continue'
          @run(name) callback
        else
          callback err, result

  _getId : (name) ->
    (callback) ->
      file      = "#{process.cwd()}/#{name}/manifest.json"
      manifest  = require(file)
      completed = _.filter(manifest, { 'status': 'completed'})
      created   = _.find(manifest, { 'status': 'created'})

      if not _.isEmpty(created)
        mixin.write 'cyan', "\n------------------"
        mixin.write 'cyan', "\nIndex \t\t: #{completed?.length + 1} of #{manifest?.length}"
        mixin.write 'cyan', "\nId \t\t: #{created?.id}"
        mixin.write 'cyan', "\nName \t\t: #{created?.name}"
        callback null, created?.id
      else
        mixin.write 'green', "\nDownload Complete"
        callback 'completed', null


  _getVimeoPage : ->
    (input, callback) =>
      id = input
      request
      .get("https://player.vimeo.com/video/#{id}")
      .end  (err, result) =>
        if err
          @retry++
          mixin.write 'cyan', '\nStatus \t\t: Failed'
          callback 'retry', null
        else
          @retry = 0
          callback null, result?.text

  _getRequestFiles :  ->
    (input, callback) ->
      html        = input
      regex_a     = /t={(.*)};if/
      regex_b     = /{(.*)}/
      string      = html?.match(regex_a)
      string      = string?[0]?.match(regex_b)
      object      = JSON.parse(string?[0])
      callback null, object

  _downloadVideo : (name) ->
    (input, callback) ->
      object  = input
      files   = object?.request?.files
      video   = object?.video
      url     = files?.h264?.hd?.url
      mixin.write 'cyan', "\nUrl \t\t: #{url}"
      request
        .get(url)
        .parse (res) =>
          file  = fs.createWriteStream("#{process.cwd()}/#{name}/_#{video.title} [#{video.id}].mp4");
          params        =
            complete    : '='
            incomplete  : ' '
            width       : 20
            total       : parseInt(res.headers['content-length'], 10)
          bar           = new ProgressBar 'Downloading \t: [:bar] :percent :etas', params

          res.on 'data', (chunk) =>
            bar.tick(chunk.length)
          res.on 'end',  =>
            mixin.write 'green', "Downloaded \t: #{video.title} [#{video.id}].mp4"
            callback null, video

          #
          # Write Mp4
          #
          res.pipe(file)
        .end  (err, result) ->

  _updateManifest : (name) ->
    (input, callback) ->
      video     = input
      arr       = []
      file      = "#{process.cwd()}/#{name}/manifest.json"
      manifest  = require(file)
      manifest?.forEach (item) ->
        item.status = 'completed' if parseInt(item?.id) is parseInt(video?.id)
        arr.push item
      completed = _.filter(arr, { 'status': 'completed'})
      fs.writeFile file, JSON.stringify(arr, null, 4), (err) =>
        if completed.length <= arr.length
          callback 'continue', video
        else
          callback null, video





module.exports = Download