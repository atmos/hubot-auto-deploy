# hubot-auto-deploy [![Build Status](https://travis-ci.org/atmos/hubot-auto-deploy.png?branch=master)](https://travis-ci.org/atmos/hubot-auto-deploy)

[GitHub Flow][1] via [hubot][3]. Chatting with hubot configures auto-deployment on GitHub and dispatches [Deployment Events][4] when criteria is met.

This script interacts with the GitHub API to manage the [Automated Deployment service][6] built in to GitHub services.

## Installation

* Add hubot-auto-deploy to your `package.json` file.
* Add hubot-auto-deploy to your `external-scripts.json` file.

## Runtime Environment

You need to set the following environmental variables.

| Environmental Variables |                                                 |
|-------------------------|-------------------------------------------------|
| HUBOT_GITHUB_TOKEN            |A [GitHub token](https://github.com/settings/applications#personal-access-tokens) with [repo:deployment](https://developer.github.com/v3/oauth/#scopes). The owner of this token creates [Deployments][5].

## TODO

* Implement the status based workflow
* Preserve payload from previous deployments for chat meta info
* Handle automated deployment of non-default branches.

## See Also

* [hubot](https://github.com/github/hubot) - A chat robot with support for a lot of networks.
* [heaven](https://github.com/atmos/heaven) - Listens for Deployment events from GitHub and executes the deployment for you.
* [hubot-deploy](https://github.com/atmos/hubot-deploy) - Request deployments on GitHub from your chat client.

[1]: https://guides.github.com/overviews/flow/
[2]: https://developer.github.com/v3/repos/hooks/
[3]: https://hubot.github.com
[4]: https://developer.github.com/v3/activity/events/types/#deploymentevent
[5]: https://developer.github.com/v3/repos/deployments/
[6]: https://github.com/github/github-services/blob/master/lib/services/auto_deploy.rb
