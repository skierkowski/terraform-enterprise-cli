

module TerraformEnterprise
  module CommandLine
    STRINGS = {
      options: {
        table: 'Format list output as a table',
        host: 'Set host address for private Terraform Enterprise',
        token: 'Set the auth token, defaults to TFE_TOKEN environment variable',
        color: 'If disabled the ANSI color codes will not be used',
        except: 'List of fields that should not be displayed',
        only: 'List of fields that should be displayed',
        all: 'Return all fields, not just summary',
        value: 'Only return the value; i.e. do not show keys',
        debug: 'Show debug logs'
      },
      push: {
        attributes: {
          path: 'Path of directory or tar.gz file to push to the workspace'
        },
        commands: {
          push: 'Pushes the configuration to the workspace'
        }
      },
      version: {
        commands: {
          version: 'Show current version'
        }
      },
      workspaces: {
        attributes: {
          terraform_version: 'Version of Terraform to use for this workspace.',
          working_directory: 'Relative path that Terraform will execute within.',
          oauth_token: 'VCS Connection (OAuth Conection + Token) to use as identified; obtained from the oauth_tokens subcommand.',
          branch: 'Repository branch that Terraform will execute from.',
          ingress_submodules: 'Submodules should be fetched when cloning the VCS repository.',
          repo: 'Reference to VCS repository in the format :org/:repo.',
          import_legacy: 'Specifies the legacy Environment to use as the source of the migration/',
          organization: 'Organization to which this workspaces belongs to.',
          auto_apply: 'Auto-apply enabled'
        },
        commands: {
          create: 'Create a new workspace',
          list: 'List workspaces in the organization',
          get: 'Get workspace details by name',
          delete: 'Delete the workspace',
          update: 'Update the workspace',
          lock: 'Lock the workspace by workspace ID',
          unlock: 'Unlock the workspace by workspace ID'
        }
      },
      configuration_versions: {
        attributes: {
          workspace_id: 'Workspace ID of the workspace to which the configuration version belongs to.',
          path: 'Path of directory or tar.gz file to push to the workspace'
        },
        commands: {
          create: 'Create a new configuration version',
          list: 'List configuration versions in the organization',
          get: 'Get configuration version details by name',
          upload: 'Upload a file to the configuration version'
        }
      },
      organizations: {
        commands: {
          create: 'Create a new organization',
          list: 'List all the organizations',
          get: 'Get organization details by name',
          delete: 'Delete the organization'
        },
        attributes: {}
      },
      teams: {
        commands: {
          create: 'Create a new team',
          delete: 'Delete the team by ID',
          list: 'List teams in organization',
          get: 'Get team details'
        },
        attributes: {
          organization: 'Organization to which this Team belongs to.'
        }
      },
      policies: {
        commands: {
          create: 'Create a new policy',
          delete: 'Delete a policy by ID',
          list: 'List policies in organization',
          get: 'Get policy details',
          upload: 'Upload a policy'
        },
        attributes: {
          organization: 'Organization to which this Team belongs to.',
          mode: 'Policy mode, hard-mandatory, soft-mandatory or advisory',
          name: 'Policy name'
        }
      },
      runs: {
        commands: {
          create: 'Create a new run',
          list: 'List runs in a workspace',
          get: 'Get run details',
          apply: 'Apply the plan',
          discard: 'Discard the plan',
          log: 'Return logs for the plan or apply'
        },
        attributes: {
          workspace_id: 'Workspace ID of which the run belongs to.',
          configuration_version_id: 'Configuration Version ID of the configuration version to run',
          destroy: 'The run should be a destroy plan',
          comment: 'Add a comment for the action',
          follow: 'Follow the logs until output is complete',
          event: 'Run event for which to get logs (plan or apply)'
        }
      },
      policy_checks: {
        commands: {
          list: 'List policy checks on run',
          override: 'Override the soft-mandatory or advisory policy'
        },
        attributes: {
          run_id: 'Run ID to which the policy check belongs to.',
          comment: 'Add a comment for the action'
        }
      },
      oauth_tokens: {
        commands: {
          list: 'List the OAuth tokens in the organization'
        },
        attributes: {
          organization: 'Organization to which this OAuth Token belongs to.'
        }
      },
      variables: {
        commands: {
          create: 'Create a new variable',
          delete: 'Delete the variable by ID',
          get: 'Get variable details',
          list: 'List variables in organization',
          update: 'Update a variable by ID'
        },
        attributes: {
          organization: 'Organization to which this Variable belongs to.',
          workspace: 'Workspace to which this Variable belongs to.',
          category: 'The type of category, probably "terraform" or "env"',
          hcl: 'Variable should be parsed using HCL',
          sensitive: 'Variable should be marked as sensitive',
          value: 'Variable value',
          key: 'Variable key'
        }
      }
    }.freeze
  end
end
