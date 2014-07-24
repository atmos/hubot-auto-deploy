Fs      = require "fs"
Path    = require "path"
Version = require(Path.join(__dirname, "version")).Version
###########################################################################

api = require("octonode").client(process.env.HUBOT_GITHUB_TOKEN or 'unknown')
api.requestDefaults.headers['Accept'] = 'application/vnd.github.cannonball-preview+json'
###########################################################################

Array::unique = ->
  output = {}
  output[@[key]] = @[key] for key in [0...@length]
  value for key, value of output

class Hook
  @APPS_FILE = process.env['HUBOT_DEPLOY_APPS_JSON'] or "apps.json"

  constructor: (@name, @token) ->
    @environments     = [ "production" ]
    @requiredContexts = [ ]

    @active           = true
    @config           = null
    @deployOnStatus   = false

    @token          or= process.env.HUBOT_GITHUB_TOKEN

    try
      applications = JSON.parse(Fs.readFileSync(@constructor.APPS_FILE).toString())
    catch
      throw new Error("Unable to parse your apps.json file in hubot-auto-deploy")

    @application = applications[@name]

    if @application?
      @repository = @application['repository']

      @configureRequiredContexts()
      @configureEnvironments()

  isValidApp: ->
    @application?

  isActive: ->
    if @config
      @config.active == true
    else
      @active

  isDeployingOnPush: ->
    if @config
      @config.config.deploy_on_push == '1'
    else
      not @deployOnStatus

  isDeployingOnStatus: ->
    if @config
      @config.config.deploy_on_status == '1'
    else
      @deployOnStatus

  attrEnabled: (val) ->
    if val then "1" else "0"

  statusContexts: ->
    if @requiredContexts
      @requiredContexts.unique().join(',')
    else
      "default"

  requestBody: ->
    name: "autodeploy"
    events: ["push", "status"]
    active: @isActive()
    config:
      github_token: @token
      environments: @environments.unique().join(',')
      deploy_on_push: @attrEnabled(@isDeployingOnPush())
      deploy_on_status: @attrEnabled(@isDeployingOnStatus())
      status_contexts: @statusContexts()

  disable: (cb) ->
    @active = false
    @config.active = false if @config
    @save(cb)

  enable: (cb) ->
    @active = true
    @config.active = true if @config
    @save(cb)

  enableStatusDeployment: (cb) ->
    if @config
      @config.config.deploy_on_push   = '0'
      @config.config.deploy_on_status = '1'
    @deployOnStatus = true
    @enable(cb)

  enablePushDeployment: (cb) ->
    if @config
      @config.config.deploy_on_push   = '1'
      @config.config.deploy_on_status = '0'
    @deployOnStatus = false
    @enable(cb)

  isDeployingOnStatus: ->
    if @config
      @config.config.deploy_on_status == '1'

  statusLine: ->
    str  = "#{@name} is "
    if @config and @config.active == true
      str += "auto-deploying on"
      if @config.config.deploy_on_status == '1'
        str += " green commit statuses to the master branch."
      else
        str += " pushes to the master branch."
      str += " Environments: #{@config.config.environments}."
    else
      str += "not auto-deploying."
    str

  save: (cb) ->
    if @config
      @patch (err, data) ->
        cb(err, data)
    else
      @post (err, data) ->
        cb(err, data)

  get: (cb) ->
    path = "repos/#{@repository}/hooks"

    api.get path, {}, (err, status, body, headers) =>
      hooks = (hook for hook in body when hook.name is "autodeploy")
      @config = hooks[0] if hooks.length > 0
      cb(err)

  patch: (cb) ->
    path     = "repos/#{@repository}/hooks/#{@config.id}"
    postBody = @requestBody()

    api.post path, postBody, (err, status, body, headers) ->
      cb(err, body)

  post: (cb) ->
    path     = "repos/#{@repository}/hooks"
    postBody = @requestBody()

    api.post path, postBody, (err, status, body, headers) ->
      cb(err, body)

  # Private Methods
  configureEnvironments: ->
    if @application['environments']?
      @environments = @application['environments']

  configureRequiredContexts: ->
    if @application['required_contexts']?
      @requiredContexts = @application['required_contexts']

exports.Hook = Hook
