# frozen_string_literal: true

class Extractor
  def self.extract(json)
    json.dig('list').take(half_day).each do |item|
      if likely_to_rain?(item)
        yield(forecast_time(item))
        return
      end
    end
  end

  # TODO: Extract に判定をいれるべきではない. あとで別の場所に置く
  def self.likely_to_rain?(item)
    item.dig('weather').first.dig('main') == 'Rain'
  end

  def self.utc_to_jst(utc)
    utc + Rational(9, 24)
  end

  # TODO: Extract に書くものではない.
  # 日本時間に修正する
  def self.forecast_time(item)
    utc_to_jst(DateTime.parse(item.dig('dt_txt')))
  end

  def self.half_day
    4
  end

  private_class_method :likely_to_rain?, :forecast_time, :half_day, :utc_to_jst
end
