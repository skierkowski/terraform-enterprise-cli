require 'terraform_enterprise/command_line/command'

module TerraformEnterprise
  module CommandLine
    module Commands
      class PoliciesCommand < TerraformEnterprise::CommandLine::Command
        ATTR_STR = STRINGS[:policies][:attributes]
        CMD_STR = STRINGS[:policies][:commands]

        desc 'list', CMD_STR[:list]
        option :table, type: :boolean, default: true, desc: STRINGS[:options][:table]
        option :organization, required: true, type: :string, desc: ATTR_STR[:organization]
        def list
          render client.policies.list(organization: options[:organization])
        end

        desc 'create <name>', CMD_STR[:create]
        option :organization, required: true, type: :string, desc: ATTR_STR[:organization]
        option :mode, type: :string, required: true, enum: ['soft-mandatory', 'hard-mandatory', 'advisory']
        def create(name)
          params = {
            name: name,
            organization: options[:organization],
            enforce: [
              {
                path: "#{name}.sentinel",
                mode: options[:mode]
              }
            ]
          }
          render client.policies.create(params)
        end

        desc 'update <id>', CMD_STR[:create]
        option :mode, type: :string, required: true, enum: ['soft-mandatory', 'hard-mandatory', 'advisory'], desc: ATTR_STR[:mode]
        def update(id)
          name = ''
          params = {
            id: id,
            name: name,
            enforce: [
              {
                path: 'default.sentinel',
                mode: options[:mode]
              }
            ]
          }

          render client.policies.update(params)
        end

        desc 'get <id>', CMD_STR[:get]
        def get(id)
          render client.policies.get(id:id)
        end

        desc 'delete <id>', CMD_STR[:delete]
        def delete(id)
          render client.policies.delete(id: id)
        end

        desc 'upload <path> <policy-id>', CMD_STR[:upload]
        def upload(path, policy_id)
          full_path = File.expand_path(path)
          content = File.read(full_path)

          params = { content: content, id: policy_id }

          render client.policies.upload(params)
        end
      end
    end
  end
end