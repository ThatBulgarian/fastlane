module Fastlane
  module Actions
    module SharedValues; end

    class TeamIdAction < Action
      def self.run(params)
        params = nil unless params.kind_of?(Array)
        team = (params || []).first
        unless team.to_s.length > 0
          UI.user_error!("Please pass your Team ID (e.g. team_id 'Q2CBPK58CA')")
        end

        UI.message("Setting Team ID to '#{team}' for all build steps")

        %i[
          CERT_TEAM_ID
          SIGH_TEAM_ID
          PEM_TEAM_ID
          PRODUCE_TEAM_ID
          SIGH_TEAM_ID
          FASTLANE_TEAM_ID
        ].each { |current| ENV[current.to_s] = team }
      end

      def self.author
        'KrauseFx'
      end

      def self.description
        'Specify the Team ID you want to use for the Apple Developer Portal'
      end

      def self.is_supported?(platform)
        platform == :ios
      end

      def self.example_code
        %w[team_id("Q2CBPK58CA")]
      end

      def self.category
        :misc
      end
    end
  end
end
