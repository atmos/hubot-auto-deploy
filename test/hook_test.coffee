Path = require('path')

Hook = require(Path.join(__dirname, "..", "src", "hook")).Hook

describe "Hook fixtures", () ->
  describe "#isValidApp()", () ->
    it "is invalid if the app can't be found", () ->
      hook = new Hook("hubot-reloaded")
      assert.equal(hook.isValidApp(), false)

    it "is valid if the app can be found", () ->
      hook = new Hook("hubot-deploy")
      assert.equal(hook.isValidApp(), true)

  describe "#requiredContexts", () ->
    it "works with required contexts", () ->
      hook = new Hook("hubot")
      expectedContexts = ["ci/janky", "ci/travis-ci"]

      assert.deepEqual(expectedContexts, hook.requiredContexts)

  describe "#requestBody()", () ->
    it "verifies deploy on attributes", () ->
      hook = new Hook("hubot")
      body = hook.requestBody()
      assert.equal("1", body.active)
      assert.equal("autodeploy", body.name)
      assert.equal("0", body.config.deploy_on_status)
      assert.equal("production", body.config.environments)
      assert.equal("ci/janky,ci/travis-ci", body.config.contexts)
    
    it "handles unique environments etc", () ->
      hook = new Hook("hubot")
      hook.requiredContexts = null
      hook.active           = false
      hook.deployOnStatus   = true
      hook.environments.push("staging")
      hook.environments.push("production")

      body = hook.requestBody()
      assert.equal("0", body.active)
      assert.equal("autodeploy", body.name)
      assert.equal("1", body.config.deploy_on_status)
      assert.equal("production,staging", body.config.environments)
      assert.equal("", body.config.contexts)

