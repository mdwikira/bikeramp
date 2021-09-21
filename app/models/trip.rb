require 'active_support'
require 'date'

class Trip < ApplicationRecord
    validates :price_before_type_cast, presence: true, format: {with: /\A\d+\.?\d{0,2}\z/, message: "missing or invalid format."}
    validates :delivery_date, presence: true
    validates :distance, presence: true

    def self.weekly_summary
        stats = Trip.where("delivery_date >= ?", current_week_start).pluck("SUM(price), SUM(distance)")
        total_price = stats[0][0].nil? ? 0 : stats[0][0]
        total_distance_meters = stats[0][1].nil? ? 0 : stats[0][1]
        return {
            :total_distance => format_distance(total_distance_meters),
            :total_price => format_price(total_price)
        }
    end

    def self.monthly_summary
        stats = Trip.where("delivery_date >= ?", current_month_start).group("delivery_date").pluck("delivery_date, SUM(distance), AVG(distance), AVG(price)")

        stats.map{|s| {
            :day => format_day(s[0]),
            :total_distance => format_distance(s[1]),
            :avg_ride => format_distance(s[2]),
            :avg_price => format_price(s[3])
        }}
    end

    private

    def self.current_week_start
        d = Date.today
        return d-d.wday
    end

    def self.current_month_start
        d = Date.today
        return d-d.mday
    end

    def self.format_day(d)
        return "#{Date::MONTHNAMES[d.mon]}, #{d.mday.ordinalize}"
    end

    def self.format_distance(d)
        return "#{(d/1000).round(0)}km"
    end

    def self.format_price(p)
        return "#{p.round(2)}PLN"
    end

end
