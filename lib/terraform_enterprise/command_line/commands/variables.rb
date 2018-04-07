require 'terraform_enterprise/command_line/command'

module TerraformEnterprise
  module CommandLine
    module Commands
      class VariablesCommand < TerraformEnterprise::CommandLine::Command
        ATTR_STR = STRINGS[:variables][:attributes]
        CMD_STR = STRINGS[:variables][:commands]

        desc 'list', CMD_STR[:list]
        option :table, type: :boolean, default: true, desc: STRINGS[:options][:table]
        option :organization, required: true, type: :string, desc: ATTR_STR[:organization]
        option :workspace, type: :string, desc: ATTR_STR[:workspace]
        def list
          render client.variables.list(options)
        end

        desc 'create <key> <value>', CMD_STR[:create]
        option :organization, required: true, type: :string, desc: ATTR_STR[:organization]
        option :workspace, required: true, type: :string, desc: ATTR_STR[:workspace]
        option :category, default: 'terraform', type: :string, desc: ATTR_STR[:category], enum:['terraform', 'env']
        option :hcl, default: false, type: :boolean, desc: ATTR_STR[:hcl]
        option :sensitive, default: false, type: :boolean, desc: ATTR_STR[:sensitive]
        def create(key, value)
          params = {
            category: options[:category],
            hcl: options[:hcl],
            key: key,
            organization: options[:organization],
            sensitive: options[:sensitive],
            value: value,
            workspace: options[:workspace],
          }
          render client.variables.create(params)
        end

        desc 'update <id>', CMD_STR[:update]
        option :hcl, type: :boolean, desc: ATTR_STR[:hcl]
        option :sensitive, type: :boolean, desc: ATTR_STR[:sensitive]
        option :key, type: :string, desc: ATTR_STR[:key]
        option :value, type: :string, desc: ATTR_STR[:value]
        def update(id)
          params             = {id: id}
          params[:hcl]       = options[:hcl] if options.include?('hcl')
          params[:key]       = options[:key] if options[:key]
          params[:sensitive] = options[:sensitive] if options.include?('sensitive')
          params[:value]     = options[:value] if options[:value]
          render client.variables.update(params)
        end

        desc 'get <id>', CMD_STR[:get]
        def get(id)
          render client.variables.get(id:id)
        end

        desc 'delete <id>', CMD_STR[:delete]
        def delete(id)
          render client.variables.delete(id: id)
        end
      end
    end
  end
end