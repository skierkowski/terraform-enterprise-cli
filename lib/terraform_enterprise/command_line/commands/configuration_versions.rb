require 'terraform_enterprise/command_line/command'

module TerraformEnterprise
  module CommandLine
    module Commands
      # Configuration Version Commoand
      class ConfigurationVersionsCommand < TerraformEnterprise::CommandLine::Command
        ATTR_STR = STRINGS[:configuration_versions][:attributes]
        CMD_STR = STRINGS[:configuration_versions][:commands]

        desc 'list', CMD_STR[:list]
        option :table, type: :boolean, default: true, desc: STRINGS[:options][:table]
        option :workspace_id, required: true, type: :string, desc: ATTR_STR[:workspace_id]
        def list
          render client.configuration_versions.list(workspace: options[:workspace_id])
        end

        desc 'create', CMD_STR[:list]
        option :workspace_id, required: true, type: :string, desc: STRINGS[:options][:workspace_id]
        def create
          render client.configuration_versions.create(workspace: options[:workspace_id])
        end

        desc 'get <id>', CMD_STR[:get]
        def get(id)
          render client.configuration_versions.get(id: id)
        end

        desc 'upload <upload-url>', CMD_STR[:upload]
        option :path, default: '.', type: :string, desc: ATTR_STR[:path]
        def upload(url)
          content = tarball(options[:path])
          params  = { content: content, url: url }

          render client.configuration_versions.upload(params)
        end
      end
    end
  end
end
