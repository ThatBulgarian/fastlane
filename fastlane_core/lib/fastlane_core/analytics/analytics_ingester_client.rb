require 'faraday'
require 'openssl'
require 'json'

require_relative '../helper'

module FastlaneCore
  class AnalyticsIngesterClient
    GA_URL = 'https://www.google-analytics.com'

    private_constant :GA_URL

    def initialize(ga_tracking)
      @ga_tracking = ga_tracking
    end

    def post_event(event)
      # If our users want to opt out of usage metrics, don't post the events.
      # Learn more at https://docs.fastlane.tools/#metrics
      if Helper.test? || FastlaneCore::Env.truthy?('FASTLANE_OPT_OUT_USAGE')
        return nil
      end

      return Thread.new { send_request(event) }
    end

    def send_request(event, retries: 2)
      post_request(event)
    rescue StandardError
      retries -= 1
      retry if retries >= 0
    end

    def post_request(event)
      connection =
        Faraday.new(GA_URL) do |conn|
          conn.request(:url_encoded)
          conn.adapter(Faraday.default_adapter)
        end
      connection.headers[:user_agent] = 'fastlane/' + Fastlane::VERSION
      connection.post(
        '/collect',
        {
          v: '1',
          # API Version
          tid: @ga_tracking,
          cid:
            # Tracking ID / Property ID
            event[
              :client_id
            ],
          # Client ID
          t: 'event',
          ec:
            # Event hit type
            event[
              :category
            ],
          ea:
            # Event category
            event[
              :action
            ],
          el:
            # Event action
            event[
              :label
            ] ||
              'na',
          ev:
            # Event label
            event[
              :value
            ] ||
              '0',
          # Event value
          aip: '1' # IP anonymization
        }
      )
    end
  end
end
