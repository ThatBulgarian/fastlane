module Fastlane
  module Actions
    class GitCommitAction < Action
      def self.run(params)
        if params[:path].kind_of?(String)
          paths = params[:path].shellescape
        else
          paths = params[:path].map(&:shellescape).join(' ')
        end

        skip_git_hooks = params[:skip_git_hooks] ? '--no-verify' : ''

        result =
          Actions.sh(
            "git commit -m #{params[:message]
              .shellescape} #{paths} #{skip_git_hooks}"
              .strip
          )
        UI.success("Successfully committed \"#{params[:path]}\" 💾.")
        return result
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        'Directly commit the given file with the given message'
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :path,
            description: 'The file you want to commit',
            is_string: false
          ),
          FastlaneCore::ConfigItem.new(
            key: :message, description: 'The commit message that should be used'
          ),
          FastlaneCore::ConfigItem.new(
            key: :skip_git_hooks,
            description: 'Set to true to pass --no-verify to git',
            type: Boolean,
            optional: true
          )
        ]
      end

      def self.output; end

      def self.return_value
        nil
      end

      def self.authors
        %w[KrauseFx]
      end

      def self.is_supported?(platform)
        true
      end

      def self.example_code
        [
          'git_commit(path: "./version.txt", message: "Version Bump")',
          'git_commit(path: ["./version.txt", "./changelog.txt"], message: "Version Bump")',
          'git_commit(path: ["./*.txt", "./*.md"], message: "Update documentation")',
          'git_commit(path: ["./*.txt", "./*.md"], message: "Update documentation", skip_git_hooks: true)'
        ]
      end

      def self.category
        :source_control
      end
    end
  end
end
