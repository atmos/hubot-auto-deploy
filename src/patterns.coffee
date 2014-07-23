repository = "([-_\.0-9a-z]+)"

scriptPrefix = process.env['HUBOT_AUTO_DEPLOY_PREFIX'] || "auto-deploy"

# The :hammer: regex that handles all /auto-deploy requests
AUTO_DEPLOY_SYNTAX = ///
  (#{scriptPrefix}(?:\:[^\s]+)?)  # / prefix
  \s+#{repository}                # application name, from apps.json
  (?:\s+(?:to|in|on)\s+           # http://i.imgur.com/3KqMoRi.gif
  #{repository}                   # Environment to release to
  (?:\/([^\s]+))?)?               # Host filter to try
///i


exports.AutoDeployPrefix   = scriptPrefix
exports.AutoDeployPattern  = AUTO_DEPLOY_SYNTAX
