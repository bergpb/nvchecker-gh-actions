# nvchecker-github-actions

![nvchecker](https://github.com/bergpb/nvchecker-github-actions/workflows/nvchecker/badge.svg) ![Build Docker Image](https://github.com/bergpb/nvchecker-github-actions/workflows/Build%20Docker%20Image/badge.svg)

This repo is based on [sunlei/nvchecker](https://github.com/sunlei/nvchecker), thanks for sharing that.

Use [nvchecker](https://github.com/lilydjwg/nvchecker) + GitHub Actions to regularly check for new versions of software/packages and notify using Gotify service.

## Illustrate

Usually use / attention to some of the software / packages have a new version, there is no good way to learn at the first time, tried some services, it is difficult to meet various situations, so I wrote one, get the version change and Changelog and email notification, but only adapted to GitHub and PyPi.

It was later discovered that [nvchecker](https://github.com/lilydjwg/nvchecker) was flexible and most of the time, so based on GitHub Actions, it was implemented to regularly check for new versions of software/packages and notify them by email, but nvchecker can only check for version changes at present, and cannot get Changelog, but it is enough.

## Usage

Settings - Secrets：

- GOTIFY_SERVER
- GOTIFY_TOKEN
