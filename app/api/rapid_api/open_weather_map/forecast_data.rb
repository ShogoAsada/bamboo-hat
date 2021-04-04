# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'openssl'
require 'json'

module RapidApi
  module OpenWeatherMap 
    class ForecastData
      class << self
        def response_to_json
          response = request!(URI.parse(api_url))

          JSON.parse(response.read_body)
        end

        private

        def request!(url)
          http_client = setup_http_client(url)
          request_client = setup_request_client(url)

          response = http_client.request(request_client)
        end

        def setup_http_client(url)
          http = Net::HTTP.new(url.host, url.port)
          http.use_ssl = true

          http
        end

        def setup_request_client(url)
          request = Net::HTTP::Get.new(url)
          request["x-rapidapi-key"] = ENV.fetch('RAPID_API_KEY')

          request
        end

        def api_url
          "https://community-open-weather-map.p.rapidapi.com/forecast?#{URI.encode_www_form(default_query)}"
        end

        def default_query
          {
            id: ENV.fetch('CITY_ID'),
            units: 'metric',
            lang: 'ja'
          }
        end
      end
    end
  end
end
