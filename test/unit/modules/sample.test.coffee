'use strict'

Module = require('../../../app/modules/Sample')

describe 'Module `Sample`', ->

  beforeEach ->
    @module = new Module()

  afterEach ->
    @module = null

  it 'should be an instance', ->
    expect(@module).to.be.an.instanceof(Module)