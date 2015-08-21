'use strict'

request = require('superagent')
chalk   = require('chalk')
fs      = require('fs')

class Manifest

  _downloadManifest : (name, page, callback) ->
    per_page  = 50
    request
    .get("https://#{process.env.VIMEO_HOST}/users/#{name}/videos?page=#{page}&per_page=#{per_page}")
    .set('Content-Type', process.env.VIMEO_CONTENT_TYPE)
    .set('Authorization', process.env.VIMEO_AUTHORIZATION)
    .set('host', "#{process.env.VIMEO_HOST}")
    .end  (err, result) =>
      return err if err
      data      = result.body?.data
      data?.forEach (item) =>
        @manifest.push
          id      : parseInt(item?.uri?.split('/')?[2])
          name    : item?.name
          status  : 'created'

      process.stdout.write chalk.cyan "\nDownloading manifest... #{@manifest.length} of #{result.body.total}\r"
      return @_downloadManifest(name, page + 1, callback) if @manifest.length isnt result.body.total
      process.stdout.write chalk.green "\nDownloading manifest : done"
      process.stdout.write chalk.blue "\nWriting `manifest.json`..."
      file = "#{process.cwd()}/#{name}/manifest.json"
      fs.writeFile file, JSON.stringify(@manifest, null, 4), (err) =>
        process.stdout.write chalk.green "\nWriting `manifest.json` : done"
        callback err, @manifest

  constructor : ->
    @manifest = []

  create : (name) ->
    (callback) =>
      process.stdout.write chalk.blue "\nCreating `manifest.json`..."
      @_downloadManifest(name, 1, callback)





module.exports = Manifest