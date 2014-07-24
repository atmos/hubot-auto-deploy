Path   = require("path")
Helper = require('hubot-test-helper')

pkg = require Path.join __dirname, "..", 'package.json'
pkgVersion = pkg.version

room   = null
helper = new Helper(Path.join(__dirname, "..", "src", "script.coffee"))

describe "The Hubot Script", () ->
  beforeEach () ->
    room = helper.createRoom()

  it "displays the version", () ->
    room.user.say "atmos", "hubot auto-deploy:help hubot"
    expected = "@atmos auto-deploy:help is unavailable. Sorry."
    assert.deepEqual ["atmos", "hubot auto-deploy:help hubot"], room.messages[0]
    assert.deepEqual ["hubot", expected], room.messages[1]
