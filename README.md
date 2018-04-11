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

## Releases

All releases and changelogs are available as [Releases/Tags](https://github.com/skierkowski/terraform-enterprise-cli/releases).

## Usage

All of the resources, actions and paraeters are documented in the tool and available through the `help` subcommand.

### Basic Usage

```shell
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

```
tfe configuration-versions upload
```

### Upload a Sentinel policy

```
tfe policies upload
```

### Override a policy check

```
tfe policy-checks override
```


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
