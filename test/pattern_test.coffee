Path = require('path')

Patterns = require(Path.join(__dirname, "..", "src", "patterns"))

Pattern  = Patterns.AutoDeployPattern

describe "Patterns", () ->
  describe "AutoDeployPattern", () ->
    it "rejects things that don't start with auto-deploy", () ->
      assert !"ping".match(Pattern)
      assert !"image me pugs".match(Pattern)

    it "handles simple auto-deployment disabling", () ->
      matches = "auto-deploy:disable hubot".match(Pattern)
      assert.equal "auto-deploy:disable",  matches[1], "incorrect task"
      assert.equal "hubot",                matches[2], "incorrect app name"
      assert.equal undefined,              matches[3], "incorrect environment"
      assert.equal undefined,              matches[4], "incorrect host specification"

    it "handles simple auto-deployment enabling", () ->
      matches = "auto-deploy:enable hubot".match(Pattern)
      assert.equal "auto-deploy:enable",  matches[1], "incorrect task"
      assert.equal "hubot",               matches[2], "incorrect app name"
      assert.equal undefined,             matches[3], "incorrect environment"
      assert.equal undefined,             matches[4], "incorrect host specification"

    it "handles simple auto-deployment enabling for pushes", () ->
      matches = "auto-deploy:enable:push hubot".match(Pattern)
      assert.equal "auto-deploy:enable:push",  matches[1], "incorrect task"
      assert.equal "hubot",                    matches[2], "incorrect app name"
      assert.equal undefined,                  matches[3], "incorrect environment"
      assert.equal undefined,                  matches[4], "incorrect host specification"

    it "handles simple auto-deployment enabling for statuses", () ->
      matches = "auto-deploy:enable:status hubot".match(Pattern)
      assert.equal "auto-deploy:enable:status",  matches[1], "incorrect task"
      assert.equal "hubot",                      matches[2], "incorrect app name"
      assert.equal undefined,                    matches[3], "incorrect environment"
      assert.equal undefined,                    matches[4], "incorrect host specification"

    it "handles simple auto-deployment enabling in specific environments", () ->
      matches = "auto-deploy:enable hubot in staging".match(Pattern)
      assert.equal "auto-deploy:enable",  matches[1], "incorrect task"
      assert.equal "hubot",               matches[2], "incorrect app name"
      assert.equal "staging",             matches[3], "incorrect environment"
      assert.equal undefined,             matches[4], "incorrect host specification"
