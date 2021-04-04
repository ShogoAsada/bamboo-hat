# frozen_string_literal: true

require_relative './api/rapid_api/open_weather_map/forecast_data'
require_relative './extractor'
require_relative './notifier/notifier'

class BambooHat
  def self.run
    json = RapidApi::OpenWeatherMap::ForecastData.response_to_json
    Extractor.extract(json) do |datetime|
      notifier.notify(create_notify_message(datetime: datetime))
    end
  end

  def self.notifier
    @notifier ||= Notifier.new
  end

  def self.create_notify_message(args)
    "#{create_time_message(args[:datetime])}に雨が降るかも！\n洗濯物を部屋にいれよう"
  end

  def self.create_time_message(datetime)
    "#{datetime.hour - DateTime.now.hour}時間後"
  end

  private_class_method :notifier, :create_notify_message, :create_time_message
end
