module Fastlane
  module Actions
    class ErbAction < Action
      def self.run(params)
        template = File.read(params[:template])
        result =
          ERB.new(template).result(
            OpenStruct.new(params[:placeholders]).instance_eval { binding }
          )
        if params[:destination]
          File.open(params[:destination], 'w') { |file| file.write(result) }
        end
        if params[:destination]
          UI.message(
            "Successfully parsed template: '#{params[
              :template
            ]}' and rendered output to: #{params[:destination]}"
          )
        end
        result
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        'Allows to Generate output files based on ERB templates'
      end

      def self.details
        [
          'Renders an ERB template with `:placeholders` given as a hash via parameter.',
          'If no `:destination` is set, it returns the rendered template as string.'
        ].join("\n")
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :template,
            short_option: '-T',
            env_name: 'FL_ERB_SRC',
            description: 'ERB Template File',
            optional: false,
            is_string: true
          ),
          FastlaneCore::ConfigItem.new(
            key: :destination,
            short_option: '-D',
            env_name: 'FL_ERB_DST',
            description: 'Destination file',
            optional: true,
            is_string: true
          ),
          FastlaneCore::ConfigItem.new(
            key: :placeholders,
            short_option: '-p',
            env_name: 'FL_ERB_PLACEHOLDERS',
            description: 'Placeholders given as a hash',
            default_value: {},
            is_string: false,
            type: Hash
          )
        ]
      end

      def self.authors
        %w[hjanuschka]
      end

      def self.example_code
        [
          '# Example `erb` template:

          # Variable1 <%= var1 %>
          # Variable2 <%= var2 %>
          # <% for item in var3 %>
          #        <%= item %>
          # <% end %>

          erb(
            template: "1.erb",
            destination: "/tmp/rendered.out",
            placeholders: {
              :var1 => 123,
              :var2 => "string",
              :var3 => ["element1", "element2"]
            }
          )'
        ]
      end

      def self.category
        :misc
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
