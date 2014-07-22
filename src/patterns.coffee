repository = "([-_\.0-9a-z]+)"

scriptPrefix = process.env['HUBOT_AUTO_DEPLOY_PREFIX'] || "auto-deploy"

# The :hammer: regex that handles all /deploy requests
AUTO_DEPLOY_SYNTAX = ///
  (#{scriptPrefix}(?:\:[^\s]+)?)  # / prefix
  (!)?\s+                         # Whether or not it was a forced deployment
  #{repository}                   # application name, from apps.json
  (?:\/([^\s]+))?                 # Branch or sha to deploy
  (?:\s+(?:to|in|on)\s+           # http://i.imgur.com/3KqMoRi.gif
  #{repository}                   # Environment to release to
  (?:\/([^\s]+))?)?               # Host filter to try
///i


exports.AutoDeployPrefix   = scriptPrefix
exports.AutoDeployPattern  = AUTO_DEPLOY_SYNTAX
