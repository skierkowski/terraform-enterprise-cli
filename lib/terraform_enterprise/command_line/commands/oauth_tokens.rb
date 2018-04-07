require 'terraform_enterprise/command_line/command'

module TerraformEnterprise
  module CommandLine
    module Commands
      class OAuthTokensCommand < TerraformEnterprise::CommandLine::Command
        class_option :organization, required: true, type: :string, desc: STRINGS[:oauth_tokens][:attributes][:organization]

        desc 'list', STRINGS[:oauth_tokens][:commands][:list]
        option :table, type: :boolean, default: true, desc: STRINGS[:options][:table]
        def list
          render client.oauth_tokens.list(options)
        end
      end
    end
  end
end