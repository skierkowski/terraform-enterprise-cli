require 'terraform_enterprise/command_line/command'

module TerraformEnterprise
  module CommandLine
    class WorkspacesCommand < TerraformEnterprise::CommandLine::Command
      ATTR_STR = STRINGS[:workspaces][:attributes]
      CMD_STR = STRINGS[:workspaces][:commands]

      desc 'list', CMD_STR[:list]
      option :organization, required: true, type: :string, desc: ATTR_STR[:organization]
      option :table, type: :boolean, default: true, desc: STRINGS[:options][:table]
      def list
        render client.workspaces.list(options), except:[:permissions, :actions, :environment, 'created-at']
      end

      desc 'create <name>', CMD_STR[:create]
      option :terraform_version, type: :string, desc: ATTR_STR[:terraform_version]
      option :working_directory, type: :string, desc: ATTR_STR[:working_directory]
      option :oauth_token, type: :string, desc: ATTR_STR[:oauth_token]
      option :branch, type: :string, desc: ATTR_STR[:branch]
      option :ingress_submodules, type: :boolean, desc: ATTR_STR[:ingress_submodules]
      option :repo, type: :string, desc: ATTR_STR[:repos]
      option :import_legacy_environment, type: :string, desc: ATTR_STR[:import_legacy]
      option :organization, required: true, type: :string, desc: ATTR_STR[:organization]
      def create(name)
        params = {
          organization: options[:organization],
          name: name,
          'working-directory' => options[:working_directory] || '',
        }
        if options[:repo] && options[:oauth_token]
          repo = {}
          repo['branch']             = options[:branch] || ''
          repo['identifier']         = options[:repo]
          repo['oauth-token-id']     = options[:oauth_token]
          repo['ingress-submodules'] = options[:ingress_submodules] || false
          params['vcs-repo'] = repo
        end

        params['migration-environment'] = options[:import_legacy_environment] if options[:import_legacy_environment]
        params['terraform_version']     = options[:terraform_version] if options[:terraform_version]
        render client.workspaces.create(params), except:[:permissions, :actions, :environment]
      end

      desc 'get <name>', CMD_STR[:get]
      option :organization, required: true, type: :string, desc: ATTR_STR[:organization]
      def get(name)
        params = {
          organization: options[:organization],
          workspace: name
        }
        render client.workspaces.get(params), except:[:permissions, :environment]
      end

      desc 'delete <name>', CMD_STR[:delete]
      option :organization, required: true, type: :string, desc: ATTR_STR[:organization]
      def delete(name)
        params = {
          organization: options[:organization],
          workspace: name
        }
        render client.workspaces.delete(params), except:[:permissions, :actions, :environment]
      end

      desc 'update <name>', CMD_STR[:update]
      option :working_directory, type: :string, desc: ATTR_STR[:working_directory]
      option :terraform_version, type: :string, desc: ATTR_STR[:terraform_version]
      option :auto_apply, type: :boolean, desc: ATTR_STR[:auto_apply]
      option :organization, required: true, type: :string, desc: ATTR_STR[:organization]
      def update(name)
        params = options
        params[:workspace] = name
        render client.workspaces.update(params), except:[:permissions, :environment]
      end

      desc 'lock <id>', CMD_STR[:lock]
      def lock(id)
        render client.workspaces.action(action: :lock, id: id), except:[:permissions, :environment]
      end

      desc 'unlock <id>', CMD_STR[:unlock]
      def unlock(id)
        render client.workspaces.action(action: :unlock, id: id), except:[:permissions, :environment]
      end
    end
  end
end
