require 'active_support'
require 'date'

class Trip < ApplicationRecord

    def self.weekly_summary
        stats = Trip.where("delivery_date >= ?", current_week).pluck("SUM(price), SUM(distance)")
        total_price = stats[0][0].nil? ? 0 : stats[0][0]
        total_distance_meters = stats[0][1].nil? ? 0 : stats[0][1]
        return {
            :total_distance => "#{total_distance_meters/1000}km",
            :total_price => "#{total_price.round(2)}PLN"
        }
    end

    def self.monthly_summary
        stats = Trip.where("delivery_date >= ?", current_month).group("delivery_date").pluck("delivery_date, SUM(distance), AVG(distance), AVG(price)")

        stats.map{|s| {
            :day => "#{Date::MONTHNAMES[s[0].mon]}, #{s[0].mday.ordinalize}",
            :total_distance => "#{s[1]/1000}km",
            :avg_ride => "#{(s[2]/1000).round(0)}km",
            :avg_price => "#{s[3].round(2)}PLN"
        }}
    end

    private

    def self.current_week
        d = Date.today
        return d-d.wday
    end

    def self.current_month
        d = Date.today
        return d-d.mday
    end
end
