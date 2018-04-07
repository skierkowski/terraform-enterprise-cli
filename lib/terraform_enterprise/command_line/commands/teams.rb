require 'terraform_enterprise/command_line/command'

module TerraformEnterprise
  module CommandLine
    module Commands
      class TeamsCommand < TerraformEnterprise::CommandLine::Command
        ATTR_STR = STRINGS[:teams][:attributes]
        CMD_STR = STRINGS[:teams][:commands]

        desc 'list', CMD_STR[:list]
        option :table, type: :boolean, default: true, desc: STRINGS[:options][:table]
        option :organization, required: true, type: :string, desc: ATTR_STR[:organization]
        def list
          render client.teams.list(organization: options[:organization]), except: [:permissions]
        end

        desc 'create <name>', CMD_STR[:create]
        option :organization, required: true, type: :string, desc: ATTR_STR[:organization]
        def create(name)
          render client.teams.create(name: name, organization: options[:organization])
        end

        desc 'get <id>', CMD_STR[:get]
        def get(id)
          render client.teams.get(id:id), except: [:permissions]
        end

        desc 'delete <id>', CMD_STR[:delete]
        def delete(id)
          render client.teams.delete(id: id), except: [:permissions]
        end
      end
    end
  end
end