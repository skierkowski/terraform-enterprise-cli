# Terraform Enterprise Command Line Tool

A simple command line tool for the [Terraform Enterprise API](https://www.terraform.io/docs/enterprise/api/index.html).

[![Gem Version](https://badge.fury.io/rb/terraform-enterprise-cli.svg)](https://badge.fury.io/rb/terraform-enterprise-cli)
[![Maintainability](https://api.codeclimate.com/v1/badges/1fd90e8dda31d1d402e8/maintainability)](https://codeclimate.com/github/skierkowski/terraform-enterprise-cli/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/1fd90e8dda31d1d402e8/test_coverage)](https://codeclimate.com/github/skierkowski/terraform-enterprise-cli/test_coverage)

***

**This is a community project and not support by HashiCorp.** Please use the [hashicorp/tfe-cli](https://github.com/hashicorp/tfe-cli) if you require a HashiCorp supported CLI client for Terraform Enterprise. This project is maintained and supported by the community.

***

## Requirements

MRI Ruby 2.3 and newer are supported. Alternative interpreters compatible with 2.3+ should work as well.

This gem depends on these other gems for usage at runtime:

- [terraform-enterprise-client](https://github.com/skierkowski/terraform-enterprise-client)
- [colorize](https://github.com/fazibear/colorize)
- [thor](https://github.com/erikhuda/thor)
- [terminal-table](https://github.com/tj/terminal-table)

## Installation

Installing the gem `terraform-enterprise-cli` gem installs the `tfe` command line tool. Running `tfe help` provides the help information and list of available subcomands.

```bash
gem install terraform-enterprise-cli
```

## Releases

All releases and changelogs are available as [Releases/Tags](https://github.com/skierkowski/terraform-enterprise-cli/releases).

## Usage

All of the resources, actions and paraeters are documented in the tool and available through the `help` subcommand.

### Basic Usage

```bash
➭ tfe help
Commands:
  tfe configuration-versions <subcommand>          # Manage configuration versions
  tfe help [COMMAND]                               # Describe available commands or one specific command
  tfe oauth-tokens <subcommand>                    # Manage OAuth tokens
  tfe organizations <subcommand>                   # Manage organizations
  tfe policies <subcommand>                        # Manage policies
  tfe policy-checks <subcommand>                   # Manage policy checks
  tfe push <organization>/<workspace> --path=PATH  # Pushes the configuration to the workspace
  tfe runs <subcommand>                            # Manage runs
  tfe teams <subcommand>                           # Manage teams
  tfe variables <subcommand>                       # Manage variables
  tfe workspaces <subcommand>                      # Manage workspaces

Options:
  [--host=HOST]             # Set host address for private Terraform Enterprise
  [--token=TOKEN]           # Set the auth token, defaults to TFE_TOKEN environment variable
  [--color], [--no-color]   # If disabled the ANSI color codes will not be used
  [--except=one two three]  # List of fields that should not be displayed
  [--only=one two three]    # List of fields that should be displayed
  [--all], [--no-all]       # Return all fields, not just summary
  [--value], [--no-value]   # Only return the value; i.e. do not show keys
  [--debug], [--no-debug]   # Show debug logs
```

## Authentication

There are two methods for authenticating the CLI with the Terraform Enterprise API. The first is to use the `TFE_TOKEN` environment variable. The second is to pass in the token on the command line using the `--token` option. The command line option takes precendence over the environment variable.

## Using with Private Terraform Enterprise

The API for the hosted (SaaS) service at app.terraform.io is no different then private TFE. However, the host name must be updated to your private TFE instance. This can be done in one of two ways:

- Set the `TFE_HOST` environment variable to the hostname
- Set the hostname by passing in the `--host` option on the command line

**NOTE**: The hostname must also include the scheme (e.g. `https://`)

## Scripting

The CLI is designed to be easy to call from other scripts. A few command line options exist to control the output format to minimize the string parsing needed to extract the desired data from the output:

- `--no-color` (Boolean, default: false): Removes ANSI color codes from output
- `--except` (Array): Exclude particular fields from the output from being returned. This is a space-separated list of fields to be excluded from the output.
- `--only` (Array): Only return the fields selected in this space-separated list of field keys.
- `--all` (Boolean, default: false): By default most commands only return a subset of fields. Many of the APIs return additional attributes which are used by the UI and likely have little value to you. As such, they are excluded by default. This option will return all of the fields, not just the subset.
- `--value` (Boolean, default: false): The output text by default shows the key and values for each field. If this option is enabled only the value of the fields will be returned. This is particularly useful if you would like to obtain the id of a newly created resource (e.g. `tfe workspcaces create new-ws --organization my-organization --only name --value` would return only the name of the created workspace)
- `--no-table` (Boolean, default: false): For `list` subcommands format the output as a list of key/value paris instead of formatting the list in a table. 

## Commands

### Help

Get the list of all all commands and subcommands, and global options:

`tfe help`

Get the help information for a particular subcommand. For example, you can see all the operations on workspaces by running `tfe help workspaces` or `tfe workspaces help`.

`tfe help <subcommand>`
`tfe <subcommand> help`

Get help information, including the options, for a specific command. For example, to get help on listing workspcaes you can use `tfe workspaces help list`

`tfe <subcommand> help <command>`

### Managing TFE Resources

The CLI supports managing the various Terraform Enterprise resources exposed via the TFE API. Below is a table of all the subcommands and the commands for each for performing CRUD operations. The `X` indicates the operation is supported by the CLI. 

| resource / sub-command | list | get  | update | create | delete |
| ---------------------- | :--: | :--: | :----: | :----: | :----: |
| configuration-version  |  X   |  X   |        |   X    |   X    |
| oauth-tokens           |  X   |      |        |        |        |
| organizations          |  X   |  X   |        |   X    |   X    |
| policies               |  X   |  X   |   X    |   X    |   X    |
| policy-checks          |  X   |      |        |        |        |
| runs                   |  X   |  X   |        |   X    |        |
| teams                  |  X   |  X   |        |   X    |   X    |
| variables              |  X   |  X   |   X    |   X    |   X    |
| workspaces             |  X   |  X   |   X    |   X    |   X    |

### Upload a configuration-version

The configuration version is a resource in Terraform Enterprise which references the terraform configuration used in the run. The `configuration-version` resource must first be created, then a configuration must be uploaded. If you do not need such low-leve control, consider using the `tfe push` command instead.

```
tfe configuration-versions upload <upload-url>
```

**Note**: Uploading a new configuration version will also start a new run. This is behavior is implemented by  Terraform Enterprise, not the CLI or Client library.

The `upload-url` is provided in the `upload-url` attribute of the `configuration-version`. It is a very long and unique URL generated to use for uploading the configuration.

### Upload a Sentinel policy

In Terraform Enterprise the policy resource does not include the content of the policy file. The policy file is managed as another resource. As such, when creating a new policy, you must first create the policy then upload the content of the policy file. You can also upload a new policy file to an existing policy to update it.

```
tfe policies upload <path> <policy_id>
```

The `path` should refence the `*.sentinel` file which contains the content of the policy.

### Override a policy check

If a policy fails and it's mode is set as `advisory` or `soft-mandatory` it can be overridden.

```
tfe policy-checks override <policy-check-id>
```

To override the policy you will need the policy check ID. This ID is auto-generated by TFE when the policy check is executed after a successful plan. The Policy Checks can be listed using `tfe policy-checks list --run-id=<run-id>`. The Run ID can be obtained using `tfe runs list --workspace-id=<workspace-id>`.

### Apply or discard a run

If a workspace is configured with auto-apply disabled and a plan completes successfully, then the run can be applied or discarded. 

```
tfe runs apply <id>
tfe runs discard <id>
```

### Read and follow run logs (plan & apply)

When a run is strated in Terraform Enterprise it will queue the work and then execute the plan. Once the plan finishes successfully, it will automatically start an apply or it can be started manually if auto-apply is disabled. When the plan and apply execute, the output is saved in TFE. This is the same output if you ran `terraform plan` or `terraform apply` locally. These locs are accessible via the API and CLI.

```
tfe runs logs <run-id> --event=<event>
```

The `--follow` option can also be specified. If used, this will render the current logs in real time (refreshed every 2 seconds). If the the particular event has not started, then the command will sit idly waiting for the particular event to start. 

### Lock and unlock a workspace

A workspace can be locked and unlocked. Locking prevents runs from being execute, but permits in progress runs to complete. The workspace ID (not the name) is required to perform the `lock` and `unlock` action.

```
tfe workspace lock <id>
tfe workspace unlock <id>
```

### Get the Workspace ID

A few commands require the workspace ID, not the workspace and organization name. The easiest way to obtain the workspace ID given a organization name and workspace name is to use the `workspaces get` subcommand. The `--value` option will strip away the keys, and the `--only id` option will return only the ID field. As such, response will return the workspace ID. 

```
tfe workspaces get <workspace_name> --organization=<organization_name> --value --only id
```

### Get the run ID

A few command require the run ID. This can be obtained dusing the `tfe runs list` command. The command below shows a nicely formatted list with a few fields removed for brevity.

```
tfe runs list --workspace-id=<workspace_id> --except status-timestamps permissions actions
```

### Push a configuration

The `push` command is a convient command which mimics the functionality of the `terraform push` command which has been deprecated. This command performs a sequence of operations:

1. Generates the tar.gz of the current directory (or the directory set using `--path` option)
2. Given the organization and workspace name it looks up the workspace ID.
3. Creates a new configuration-version resource in that workspace
4. Uploads the configuration to the new configuration-version

```
tfe push <org>/<workspace>
```

## Contribution

Contribution to the CLI is welcome. Opening issues and pull requests is welcome and will be reviewed.

### Run locally

To run the command line binary locally, use `bundle exec` to execute it with the context of the dependent gems.

```
bundle exec ./bin/tfe
```

### Debugging

Operations internal to the CLI and API are instrumented to output additional debug logs if debugging is enabled. The logs will show the HTTP requests and responses.

Debugging can be enabled by:

- Setting the `TFE_DEBUG` environment variable to `true` by `export TFE_DEBUG=true`
- Passing in the `--debug` option on the command line.

### Command line design

Basic design principles of the command line interface:

- Resource-specific commands should be `tfe <resource> <action>`
- Required attributes should be set as parameters (e.g. `tfe workspaces create <name> <email>`
- Optional attributes should be set as options
- Relationships (member-of, belongs-to) on resources should be set as options (e.g. `tfe variables list --organization <org> --workspace <workspace>`

### Opening Issues

When opening an issue, please include the version of the CLI you are using. The version can be obtained with the `tfe version` command.
