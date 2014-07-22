# hubot-auto-deploy [![Build Status](https://travis-ci.org/atmos/hubot-auto-deploy.png?branch=master)](https://travis-ci.org/atmos/hubot-auto-deploy)

[GitHub Flow][1] via [hubot][3]. Chatting with hubot configures auto-deployment on GitHub and dispatches [Deployment Events][4] when criteria is met.

## Installation

* Add hubot-auto-deploy to your `package.json` file.
* Add hubot-auto-deploy to your `external-scripts.json` file.

## Runtime Environment

You need to set the following environmental variables.

* **HUBOT\_GITHUB\_TOKEN**: A [GitHub token](https://github.com/settings/applications#personal-access-tokens) with [repo\_deployment](https://developer.github.com/v3/oauth/#scopes). The owner of this token configures [Hooks][2].

## See Also

* [hubot-deploy](https://github.com/atmos/hubot-deploy) - Request deployments on GitHub from your chat client.

[1]: https://guides.github.com/overviews/flow/
[2]: https://developer.github.com/v3/repos/hooks/
[3]: https://hubot.github.com
[4]: https://developer.github.com/v3/activity/events/types/#deploymentevent
