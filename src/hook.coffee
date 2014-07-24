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

  constructor: (@name) ->
    @environments     = [ "production" ]
    @requiredContexts = [ ]

    @active           = true
    @config           = null
    @deployOnStatus   = false

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
    active: @attrEnabled(@isActive())
    config:
      environments: @environments.unique().join(',')
      deploy_on_push: @attrEnabled(@isDeployingOnPush())
      deploy_on_status: @attrEnabled(@isDeployingOnStatus())
      status_contexts: @statusContexts()

  statusLine: ->
    str  = "#{@name} is "
    if @config and @config.active == true
      str += "auto-deploying on"
      if @config.deploy_on_status == '1'
        str += " green commit statuses to the master branch."
      else
        str += " pushes to the master branch."
      str += " Environments: #{@config.config.environments}."
    else
      str += "not auto-deploying."
    str

  get: (cb) ->
    path = "repos/#{@repository}/hooks"

    api.get path, { }, (err, status, body, headers) =>
      hooks = (hook for hook in body when hook.name is "autodeploy")
      @config = hooks[0] if hooks.length > 0
      cb(err)

  put: (cb) ->

  post: (cb) ->
    path       = "repos/#{@repository}/hooks"
    name       = @name

    message = "Unkown callback for hooks"

    api.post path, @requestBody(), (err, status, body, headers) ->
      data = body

      if err
        data = err
        console.log err unless process.env.NODE_ENV == 'test'

      if data['message']
        bodyMessage = data['message']

      cb message

  # Private Methods
  configureEnvironments: ->
    if @application['environments']?
      @environments = @application['environments']

  configureRequiredContexts: ->
    if @application['required_contexts']?
      @requiredContexts = @application['required_contexts']

exports.Hook = Hook
