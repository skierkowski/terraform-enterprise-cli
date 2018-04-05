# Terraform Enterprise Command Line Tool
A simple command line tool for the [Terraform Enterprise API](https://www.terraform.io/docs/enterprise/api/index.html).

[![Gem Version](https://badge.fury.io/rb/terraform-enterprise-cli.svg)](https://badge.fury.io/rb/terraform-enterprise-cli)
[![Maintainability](https://api.codeclimate.com/v1/badges/1fd90e8dda31d1d402e8/maintainability)](https://codeclimate.com/github/skierkowski/terraform-enterprise-cli/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/1fd90e8dda31d1d402e8/test_coverage)](https://codeclimate.com/github/skierkowski/terraform-enterprise-cli/test_coverage)
[![Dependency Status](https://gemnasium.com/badges/github.com/skierkowski/terraform-enterprise-cli.svg)](https://gemnasium.com/github.com/skierkowski/terraform-enterprise-cli)

## Requirements

MRI Ruby 2.3 and newer are supported. Alternative interpreters compatible with 2.3+ should work as well.

This gem depends on these other gems for usage at runtime:

- [terraform-enterprise-client](https://github.com/skierkowski/terraform-enterprise-client)
- [colorize](https://github.com/fazibear/colorize)
- [thor](https://github.com/erikhuda/thor)
- [terminal-table](https://github.com/tj/terminal-table)

## Installation

Installing the gem `terraform-enterprise-cli` gem installs the `tfe` command line tool. Running `tfe help` provides the help information and list of available subcomands.

## Usage

All of the resources, actions and paraeters are documented in the tool and available through the `help` subcommand.

### Basic Usage

```shell
➭ tfe help
Commands:
  tfe configuration_versions <subcommand>  # Manage configuration versions
  tfe help [COMMAND]                       # Describe available commands or one specific command
  tfe oauth_tokens <subcommand>            # Manage OAuth tokens
  tfe organizations <subcommand>           # Manage organizations
  tfe teams <subcommand>                   # Manage teams
  tfe variables <subcommand>               # Manage variables
  tfe workspaces <subcommand>              # Manage workspaces
```

## Authentication

There are two methods for authenticating the CLI with the Terraform Enterprise API. The first is to use the `TFE_TOKEN` environment variable. The second is to pass in the token on the command line using the `--token` option. The command line option takes precendence over the environment variable.

## Scripting

The CLI is designed to be easy to call from other scripts. A few command line options exist to control the output format to minimize the string parsing needed to extract the desired data from the output:

- `--no-color` (Boolean, default: false): Removes ANSI color codes from output
- `--except` (Array): Exclude particular fields from the output from being returned. This is a space-separated list of fields to be excluded from the output.
- `--only` (Array): Only return the fields selected in this space-separated list of field keys.
- `--all` (Boolean, default: false): By default most commands only return a subset of fields. Many of the APIs return additional attributes which are used by the UI and likely have little value to you. As such, they are excluded by default. This option will return all of the fields, not just the subset.
- `--value` (Boolean, default: false): The output text by default shows the key and values for each field. If this option is enabled only the value of the fields will be returned. This is particularly useful if you would like to obtain the id of a newly created resource (e.g. `tfe workspcaces create new-ws --organization my-organization --only name --value` would return only the name of the created workspace)
- `--no-table` (Boolean, default: false): For `list` subcommands format the output as a list of key/value paris instead of formatting the list in a table. 

## Contribution

Contribution to the CLI is welcome. Opening issues and pull requests is welcome and will be reviewed.

### Run locally

To run the command line binary locally, use `bundle exec` to execute it with the context of the dependent gems.

```
bundle exec ./bin/tfe
```
### Command line design

Basic design principles of the command line interface:

- Resource-specific commands should be `tfe <resource> <action>`
- Required attributes should be set as parameters (e.g. `tfe workspaces create <name> <email>`
- Optional attributes should be set as options
- Relationships (member-of, belongs-to) on resources should be set as options (e.g. `tfe variables list --organization <org> --workspace <workspace>`
