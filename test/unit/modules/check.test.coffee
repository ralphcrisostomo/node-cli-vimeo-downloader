'use strict'

Module = require('../../../app/modules/Check')

describe 'Module `Check`', ->

  beforeEach ->
    @module = new Module()

  afterEach ->
    @module = null

  it 'should be an instance', ->
    expect(@module).to.be.an.instanceof(Module)

  it 'should create directory if it is not existing', (done) ->
    name = 'test/sandbox/sample'
    @timeout(2000)
    @module._checkDirectory(name) (err, result) ->
      done()

  it 'should check if manifest existing and create one if not', (done) ->
    name = 'test/sandbox/sample'
    @timeout(2000)
    @module._checkManifest(name) (err, result) ->
      done()

