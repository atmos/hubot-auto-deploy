# Description
#   Configure auto-deployment of GitHub repos from chat - https://github.com/atmos/hubot-auto-deploy
#
# Commands:
#   hubot auto-deploy:status <app> - Check the status of auto-deployment for the app in environment
#   hubot auto-deploy:toggle <app> - Toggle on/off auto-deployment for the app in all environments.
#   hubot auto-deploy:enable <app> in <env> - enable auto-deployment for the app on push in environment
#   hubot auto-deploy:disable <app> in <env> - disable auto-deployment for the app in environment
#   hubot auto-deploy:enable:push <app> - enable auto-deployment for the app on push
#   hubot auto-deploy:enable:status <app> - enable auto-deployment for the app on commit status
#
supported_tasks = [ "auto-deploy:enable", "auto-deploy:disable" ]

Path     = require("path")
Hook     = require(Path.join(__dirname, "hook")).Hook
Patterns = require(Path.join(__dirname, "patterns"))

module.exports = (robot) ->
  failureMessage = (hook, err) ->
    "Unable to access #{hook.repository} hooks. #{err.message}(#{err.statusCode})"

  robot.respond Patterns.AutoDeployPattern, (msg) ->
    task        = msg.match[1]
    name        = msg.match[2]
    environment = msg.match[3] or 'production'

    hook = new Hook(name)
    unless hook.isValidApp()
      msg.reply "Never heard of the #{name} app, sorry"
      return

    switch task
      when "auto-deploy:status"
        hook.get (err) ->
          if err
            msg.reply failureMessage(hook, err)
          else
            msg.reply hook.statusLine()
      when "auto-deploy:toggle"
        hook.get (err) ->
          if err
            msg.reply failureMessage(hook, err)
          else
            hook.toggle (err, data) ->
              msg.reply hook.statusLine()
      when "auto-deploy:enable"
        hook.get (err) ->
          if err
            msg.reply failureMessage(hook, err)
          else
            hook.addEnvironment(environment)
            hook.save (err, data) ->
              msg.reply hook.statusLine()
      when "auto-deploy:disable"
        hook.get (err) ->
          if err
            msg.reply failureMessage(hook, err)
          else
            hook.removeEnvironment(environment)
            hook.save (err, data) ->
              msg.reply hook.statusLine()
      when "auto-deploy:enable:status"
        hook.get (err) ->
          if err
            msg.reply failureMessage(hook, err)
          else
            hook.enableStatusDeployment (err, data) ->
              msg.reply hook.statusLine()
      when "auto-deploy:enable:push"
        hook.get (err) ->
          if err
            msg.reply failureMessage(hook, err)
          else
            hook.enablePushDeployment (err, data) ->
              msg.reply hook.statusLine()
      else
        msg.reply "#{task} is unavailable. Sorry."
