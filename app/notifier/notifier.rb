# frozen_string_literal: true

require 'slack-ruby-client'

class Notifier
  def initialize
    setup_config
  end

  def notify(message)
    client.chat_postMessage(channel: "#{ENV.fetch('SLACK_CHANNEL')}", text: message)
  end

  private

  def setup_config
    Slack.configure do |config|
      config.token = ENV['SLACK_OAUTH_TOKEN']
    end
  end

  def client
    @client ||= Slack::Web::Client.new
  end
end
