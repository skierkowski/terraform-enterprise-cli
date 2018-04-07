require 'terraform_enterprise/command_line/command'

module TerraformEnterprise
  module CommandLine
    module Commands
      class OrganizationsCommand < TerraformEnterprise::CommandLine::Command
        CMD_STR = STRINGS[:organizations][:commands]

        desc 'list', CMD_STR[:list]
        option :table, type: :boolean, default: true, desc: STRINGS[:options][:table]
        def list
          render client.organizations.list, only: [:id, :name, 'created-at', :email]
        end

        desc 'create <name> <email>', CMD_STR[:create]
        def create(name, email)
          render client.organizations.create(name: name, email: email)
        end

        desc 'get <name>', CMD_STR[:get]
        def get(name)
          render client.organizations.get(name:name)
        end

        desc 'delete <name>', CMD_STR[:delete]
        def delete(name)
          render client.organizations.delete(name:name)
        end
      end
    end
  end
end