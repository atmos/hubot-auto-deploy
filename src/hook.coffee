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

  isValidApp: ->
    @application?

  statusContexts: ->
    if @requiredContexts
      @requiredContexts.unique().join(',')
    else
      ""

  toggle: (cb) ->
    @active = not @active
    @save(cb)

  removeEnvironment: (environment) ->
    index = @environments.indexOf(environment)
    if index > -1
      @environments.splice(index, 1)

  addEnvironment: (environment) ->
    @environments.push(environment)

  enableStatusDeployment: (cb) ->
    @deployOnStatus = true
    @save(cb)

  enablePushDeployment: (cb) ->
    @deployOnStatus = false
    @save(cb)

  statusLine: ->
    str  = "#{@name} is "
    if @active
      str += "auto-deploying on"
      if @deployOnStatus
        str += " green commit statuses to the master branch."
      else
        str += " pushes to the master branch."
      str += " Environments: #{@environments.unique().join(',')}."
    else
      str += "not auto-deploying."
    str

  save: (cb) ->
    @post (err, data) ->
      cb(err, data)

  requestBody: ->
    name: "autodeploy"
    events: ["push", "status"]
    active: @active
    config:
      github_token: @token
      environments: @environments.unique().join(',')
      status_contexts: @statusContexts()
      deploy_on_status: @deployOnStatus

  get: (cb) ->
    path = "repos/#{@repository}/hooks"
    api.get path, {}, (err, status, body, headers) =>
      unless err
        hooks = (hook for hook in body when hook.name is "autodeploy")
        if hooks.length > 0
          @config = hooks[0]
          @environments = @config.config.environments.split(',')
          @deployOnStatus = @config.config.deploy_on_status == '1'
          @active = @config.active == true

      cb(err)

  # Private Methods
  post: (cb) ->
    path     = "repos/#{@repository}/hooks"
    postBody = @requestBody()

    if @config
      path += "/#{@config.id}"

    api.post path, postBody, (err, status, body, headers) ->
      unless err
        @environments = body.config.environments.split(',')
        @deployOnStatus = body.config.deploy_on_status == '1'
        @active = body.active == true

      cb(err, body)

  configureRequiredContexts: ->
    if @application['required_contexts']?
      @requiredContexts = @application['required_contexts']

exports.Hook = Hook
