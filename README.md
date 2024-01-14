# Python Base Images

[![Build Python Image](https://github.com/maki-it/python/actions/workflows/build-python-debian.yaml/badge.svg?branch=main)](https://github.com/maki-it/python/actions/workflows/build-python-debian.yaml)

[![Test Python Image](https://github.com/maki-it/python/actions/workflows/test-python-debian.yaml/badge.svg)](https://github.com/maki-it/python/actions/workflows/test-python-debian.yaml)

## Available Versions and Tags

| Distro | Image                                                                                    |
| ------ | ---------------------------------------------------------------------------------------- |
| Debian | [ghcr.io/maki-it/python:debian](https://github.com/maki-it/python/pkgs/container/python) |

## Usage in Github Actions

To use in Github Actions, either authenticate to ghcr.io with your Github PAT (`secrets.GITHUB_TOKEN` is not enough) or [add Actions access in the package settings](https://github.com/orgs/maki-it/packages/container/python/settings).

## Non-root User

This image runs with a non-root User:

- Name: `appuser`
- UID and GUID: `12321`
