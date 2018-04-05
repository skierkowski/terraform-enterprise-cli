require 'terraform_enterprise/command_line/command'

module TerraformEnterprise
  module CommandLine
    class RunsCommand < TerraformEnterprise::CommandLine::Command
      ATTR_STR = STRINGS[:runs][:attributes]
      CMD_STR = STRINGS[:runs][:commands]

      desc 'list', CMD_STR[:list]
      option :table, type: :boolean, default: true, desc: STRINGS[:options][:table]
      option :workspace_id, required: true, type: :string, desc: ATTR_STR[:workspace_id]
      def list
        render client.runs.list(id: options[:workspace_id]), except: [:permissions]
      end

      desc 'create', CMD_STR[:create]
      option :workspace_id, required: true, type: :string, desc: ATTR_STR[:workspace_id]
      option :configuration_version_id, type: :string, desc: ATTR_STR[:configuration_version_id]
      option :destroy, type: :boolean, default: false, desc: ATTR_STR[:destroy]
      def create
        render client.runs.create(options), except: [:permissions]
      end

      desc 'get <id>', CMD_STR[:get]
      def get(id)
        render client.runs.get(id: id), except: [:permissions]
      end

      desc 'apply <id>', CMD_STR[:apply]
      option :comment, type: :string, desc: ATTR_STR[:comment]
      def apply(id)
        params = { id: id, action: :apply }
        params[:comment] = options[:comment] if options[:comment]
        render client.runs.action(params)
      end

      desc 'discard <id>', CMD_STR[:discard]
      option :comment, type: :string, desc: ATTR_STR[:comment]
      def discard(id)
        params = { id: id, action: :discard }
        params[:comment] = options[:comment] if options[:comment]
        render client.runs.action(params)
      end

      desc 'logs <id>', 'Logs'
      option :event, type: :string, required: true, desc: ATTR_STR[:event], enum:['plan', 'apply']
      option :follow, type: :boolean, default: false, desc: ATTR_STR[:follow]
      def logs(id)
        following       = options[:follow]
        finished        = false
        exit_requested  = false
        finished_states = %w[errored canceled finished]

        # Listens for "control-c" to exit
        Kernel.trap('INT') { exit_requested = true }

        loop do
          event    = get_event_resource(id, options[:event])
          url      = event.attributes['log-read-url']
          finished = finished_states.include?(event.attributes['status'].to_s)
          logs     = RestClient.get(url).body
          
          # errase screen and go to (0,0)
          print "\033[2J" if following
          print logs

          break if !following || exit_requested || finished
          
          sleep 2
        end 
      end

      private

      def get_event_resource(id, event)
        event_type    = event == 'plan' ? 'plans' : 'applies'
        error_message = "#{options[:event].to_s.capitalize} not started yet"
        run_response  = client.runs.get(id: id, include: [event.to_sym])
        render run_response unless run_response.success?
        event_resource = run_response.resource.included.find do |er|
          er.type.to_s == event_type
        end
        error! error_message unless event_resource
        event_resource
      end
    end
  end
end
