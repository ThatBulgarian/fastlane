require 'excon'

module FastlaneCore
  class Changelog
    class << self
      def show_changes(
        gem_name, current_version, update_gem_command: 'bundle update'
      )
        did_show_changelog = false

        self.releases(gem_name).each_with_index do |release, index|
          unless Gem::Version.new(release['tag_name']) >
                 Gem::Version.new(current_version)
            next
          end
          puts('')
          puts(release['name'].green)
          puts(release['body'])
          did_show_changelog = true

          next unless index == 2
          puts('')
          puts(
            "To see all new releases, open https://github.com/fastlane/#{gem_name}/releases"
              .green
          )
          break
        end

        puts('')
        if did_show_changelog
          puts("Please update using `#{update_gem_command}`".green)
        end
      rescue StandardError
        # Something went wrong, we don't care so much about this
      end

      def releases(gem_name)
        url = "https://api.github.com/repos/fastlane/#{gem_name}/releases"
        # We have to follow redirects, since some repos were moved away into a separate org
        server_response =
          Excon.get(
            url,
            middlewares:
              Excon.defaults[:middlewares] +
                [Excon::Middleware::RedirectFollower]
          )
        JSON.parse(server_response.body)
      end
    end
  end
end
