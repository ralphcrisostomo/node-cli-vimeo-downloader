'use strict'

Module = require('../../app/app')

describe 'App', ->

  beforeEach ->
    @module = new Module()

  afterEach ->
    @module = null

  it 'should be an instance', ->
    expect(@module).to.be.an.instanceof(Module)