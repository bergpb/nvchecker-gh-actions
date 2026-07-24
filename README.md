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

### Self-hosted (Docker Swarm)

Scheduling now runs on a local swarm via [swarm-cronjob](https://github.com/crazy-max/swarm-cronjob) instead of GitHub Actions' `schedule:` trigger (kept for `workflow_dispatch`/push/PR runs only, no longer on a cron). This assumes `swarm-cronjob` is already deployed on the cluster.

1. Create the Docker secrets the stack expects (see `Secrets` below).
2. `make build && make push` (or use the published `ghcr.io/bergpb/nvchecker-gh-actions` image).
3. `docker stack deploy -c docker-compose.swarm.yml nvchecker`

`swarm-cronjob` scales the `nvchecker` service (deployed with `replicas: 0`) up to 1 on the cron schedule defined in its `swarm.cronjob.schedule` label, running `run-and-notify.sh`, which clones the repo, runs nvchecker, sends the Gotify notification, and pushes `old_ver.json`/`new_ver.json` changes back to `main`.

#### Secrets

`docker-compose.swarm.yml` references external Docker secrets instead of plain environment variables, so the values aren't stored in plaintext in the service spec. Create them from your `.envrc` before the first deploy:

```bash
source .envrc

printf '%s' "$GITHUB_TOKEN"  | docker secret create nvchecker_github_token -
printf '%s' "$GOTIFY_SERVER" | docker secret create nvchecker_gotify_server -
printf '%s' "$GOTIFY_TOKEN"  | docker secret create nvchecker_gotify_token -
```

Rotating a value means creating a new secret under a new name (Docker secrets are immutable), updating the `name:` in `docker-compose.swarm.yml`, and redeploying the stack.
