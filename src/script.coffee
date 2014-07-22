# Description
#   Configure auto-deployment of GitHub repos from chat - https://github.com/atmos/hubot-auto-deploy
#
# Commands:
#   hubot auto-deploy:enable:push <app> in <env> - enable auto-deployment for the app on push in environment
#   hubot auto-deploy:enable:status <app> in <env> - enable auto-deployment for the app on commit status in environment
#   hubot auto-deploy:disable <app> in <env> - disable auto-deployment for the app in environment
#
supported_tasks = [ "auto-deploy:enable", "auto-deploy:disable" ]

Path          = require("path")
Patterns      = require(Path.join(__dirname, "patterns"))

module.exports = (robot) ->
  robot.respond ///auto-deploy:enable///i, (msg) ->
    msg.reply "auto-deploy is unavailable"
