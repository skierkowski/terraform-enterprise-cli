require 'yaml'
require 'colorize'
require 'terminal-table'

require 'terraform-enterprise-client'

module TerraformEnterprise
  module CommandLine
    # Module with render method to render the Resource object
    class Formatter
      def render(obj, options = {})
        String.disable_colorization = !options[:color]

        if !obj.is_a?(TerraformEnterprise::API::Response)
          unkown_response(obj)
        elsif obj.success?
          render_resource(obj, options)
        elsif obj.errors?
          render_errors(obj)
        else
          unkown_response(obj.body)
        end
      end

      def error(message)
        puts "Error: #{message}".red
      end

      def success(message)
        puts message.green
      end

      private

      def unkown_response(obj)
        puts 'Unknown response'.yellow
        puts obj
        exit(false)
      end

      def render_resource(obj, options)
        if obj.resources
          puts render_resource_list(obj.resources, options)
        elsif obj.resource
          puts render_resource_item(obj.resource, options)
        else
          success "Success (#{obj.code})"
        end
      end

      def render_errors(obj)
        obj.errors.each do |error|
          message = error['detail'] || error['title'] || error.to_s
          code    = error['status'] || obj.code
          error "[#{code}] #{message}"
        end
        exit(false)
      end

      def parse_resource(resource, options)
        parsed_resource = flatten_dotted_hash(resource.attributes)
        if resource.id
          parsed_resource = { 'id' => resource.id }.merge(parsed_resource)
        end
        (options[:except] || []).each do |excluded|
          parsed_resource.delete_if do |key, _|
            key.to_s.start_with?(excluded.to_s)
          end
        end
        if options[:only] && !options[:only].empty?
          parsed_resource.select! do |key, _|
            options[:only].any? do |included|
              key.to_s.start_with?(included.to_s)
            end
          end
        end
        parsed_resource
      end

      def render_resource_item(resource, options)
        parsed_resource = parse_resource(resource, options)
        parsed_resource.keys.map do |key|
          value = parsed_resource[key]
          options[:value] ? value : "#{key.bold}: #{value}"
        end.join("\n")
      end

      def render_resource_list(resources, options)
        if options[:table] && !options[:value]
          parsed_resources = resources.map do |resource|
            parse_resource(resource, options)
          end
          keys = parsed_resources.map(&:keys).flatten.uniq
          rows = parsed_resources.map do |resource|
            keys.map { |key| resource[key] }
          end
          table = Terminal::Table.new headings: keys, rows: rows
          table
        else
          line_separator = "\n#{'-' * 10}\n"
          out = resources.map do |resource|
            render_resource_item(resource, options)
          end
          out.join(line_separator)
        end
      end

      def flatten_hash(hash, new_key = [], new_hash = {})
        if hash.is_a?(Array)
          hash.each_with_index do |item, obj|
            flatten_hash(item, new_key + [obj], new_hash)
          end
        elsif hash.is_a?(Hash)
          hash.each do |key, value|
            flatten_hash(value, new_key + [key], new_hash)
          end
        else
          return new_hash.update(new_key => hash)
        end
        new_hash
      end

      def flatten_dotted_hash(source)
        flat = flatten_hash(source)
        flat.keys.each_with_object({}) do |key, h|
          h[key.join('.')] = flat[key]
        end
      end
    end
  end
end
