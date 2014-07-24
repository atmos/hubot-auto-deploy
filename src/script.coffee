# Description
#   Configure auto-deployment of GitHub repos from chat - https://github.com/atmos/hubot-auto-deploy
#
# Commands:
#   hubot auto-deploy:status <app> in <env> - Check the status of auto-deployment for the app in environment
#   hubot auto-deploy:enable:push <app> in <env> - enable auto-deployment for the app on push in environment
#   hubot auto-deploy:enable:status <app> in <env> - enable auto-deployment for the app on commit status in environment
#   hubot auto-deploy:disable <app> in <env> - disable auto-deployment for the app in environment
#
supported_tasks = [ "auto-deploy:enable", "auto-deploy:disable" ]

Path     = require("path")
Hook     = require(Path.join(__dirname, "hook")).Hook
Patterns = require(Path.join(__dirname, "patterns"))

module.exports = (robot) ->
  robot.respond Patterns.AutoDeployPattern, (msg) ->
    task = msg.match[1]
    name = msg.match[2]

    hook = new Hook(name)
    unless hook.isValidApp()
      msg.reply "Never heard of the #{name} app, sorry"
      return

    switch task
      when "auto-deploy:status"
        hook.get (err) ->
          msg.reply hook.statusLine()
      when "auto-deploy:enable"
        msg.reply "Enabling #{name}..."
        hook.get (err) ->
          hook.enable (err, data) ->
            msg.reply hook.statusLine()
      when "auto-deploy:disable"
        msg.reply "Disabling #{name}..."
        hook.get (err) ->
          hook.disable (err, data) ->
            msg.reply hook.statusLine()
      when "auto-deploy:enable:status"
        msg.reply "Commit status enabling #{name}..."
        hook.get (err) ->
          hook.enableStatusDeployment (err, data) ->
            msg.reply hook.statusLine()
      when "auto-deploy:enable:push"
        msg.reply "Push enabling #{name}..."
        hook.get (err) ->
          hook.enablePushDeployment (err, data) ->
            msg.reply hook.statusLine()
      else
        msg.reply "#{task} is unavailable. Sorry."
