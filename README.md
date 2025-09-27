# nvchecker-github-actions

[![docker-publish](https://github.com/bergpb/nvchecker-gh-actions/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/bergpb/nvchecker-gh-actions/actions/workflows/docker-publish.yml)

This repo is based on [sunlei/nvchecker](https://github.com/sunlei/nvchecker), thanks for it.

Use [nvchecker](https://github.com/lilydjwg/nvchecker) + GitHub Actions to regularly check for new versions of software/packages and notify using Gotify service.

### First usage of Github Packages

Reference: [https://stackoverflow.com/a/72585915/6539270](https://stackoverflow.com/a/72585915/6539270)

1. Push the docker image manually;
1. Access [packages](https://github.com/bergpb?tab=packages) page and select the package created;
1. Click on [Package Settings](https://github.com/users/bergpb/packages/container/nvchecker-gh-actions/settings);
1. On the Manage Actions access section, change the package role to write (if your repo isn't linked yet, add it using Add Repository button)


### Settings - Secrets：

- GOTIFY_SERVER
- GOTIFY_TOKEN
