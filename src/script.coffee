# Description
#   Configure auto-deployment of GitHub repos from chat - https://github.com/atmos/hubot-auto-deploy
#
# Commands:
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
      when "auto-deploy:enable"
        msg.reply "auto-deploy:enable is unavailable"
      when "auto-deploy:disable"
        msg.reply "auto-deploy:disable is unavailable"
      when "auto-deploy:status"
        hook.get (err, data) ->
          msg.reply hook.statusLine()
      else
        msg.reply "auto-deploy is unavailable"
