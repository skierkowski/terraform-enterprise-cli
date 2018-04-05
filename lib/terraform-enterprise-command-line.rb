require 'thor'

require_relative 'terraform_enterprise/command_line/command'
require_relative 'terraform_enterprise/command_line/commands/configuration_versions'
require_relative 'terraform_enterprise/command_line/commands/oauth_tokens'
require_relative 'terraform_enterprise/command_line/commands/organizations'
require_relative 'terraform_enterprise/command_line/commands/policies'
require_relative 'terraform_enterprise/command_line/commands/policy_checks'
require_relative 'terraform_enterprise/command_line/commands/runs'
require_relative 'terraform_enterprise/command_line/commands/teams'
require_relative 'terraform_enterprise/command_line/commands/variables'
require_relative 'terraform_enterprise/command_line/commands/workspaces'

module TerraformEnterprise
  # Terraform Enterprise Command Line class
  class MainCommand < TerraformEnterprise::CommandLine::Command
    include TerraformEnterprise::CommandLine

    desc 'organizations <subcommand>', 'Manage organizations'
    subcommand 'organizations', OrganizationsCommand

    desc 'workspaces <subcommand>', 'Manage workspaces'
    subcommand 'workspaces', WorkspacesCommand

    desc 'oauth-tokens <subcommand>', 'Manage OAuth tokens'
    subcommand 'oauth_tokens', OAuthTokensCommand

    desc 'teams <subcommand>', 'Manage teams'
    subcommand 'teams', TeamsCommand

    desc 'variables <subcommand>', 'Manage variables'
    subcommand 'variables', VariablesCommand

    desc 'configuration-versions <subcommand>', 'Manage configuration versions'
    subcommand 'configuration_versions', ConfigurationVersionsCommand

    desc 'policies <subcommand>', 'Manage policies'
    subcommand 'policies', PoliciesCommand

    desc 'policy-checks <subcommand>', 'Manage policy checks'
    subcommand 'policy_checks', PolicyChecksCommand

    desc 'runs <subcommand>', 'Manage runs'
    subcommand 'runs', RunsCommand

    desc 'push <organization>/<workspace>', STRINGS[:push][:commands][:push]
    option :path, required: true, default: '.', desc: STRINGS[:push][:attributes][:path]
    def push(name)
      name_parts        = name.split('/')
      organization_name = name_parts[0]
      workspace_name    = name_parts[1]
      workspace_params  = {
        organization: organization_name,
        workspace: workspace_name
      }

      begin
        content = tarball(options[:path])
      rescue
        error! "Error: could not open that file or directory"
      end

      # Look up the workspace ID
      workspace_response = client.workspaces.get(workspace_params)
      workspace_id = workspace_response&.resource&.id
      error! "Error: workspace '#{organization_name}/#{workspace_name}' was not found!" unless workspace_id

      # Create a configuration version and get upload-url
      configuration_version_response = client.configuration_versions.create(workspace: workspace_id)
      upload_url = (configuration_version_response&.resource&.attributes || {})['upload-url']
      error! "Error: creationg configuration version with workspace id `#{workspace_id}`" unless upload_url      

      upload_params = { content: content, url: upload_url }
      render client.configuration_versions.upload(upload_params)
    end
  end
end

TerraformEnterprise::MainCommand.start(ARGV)
