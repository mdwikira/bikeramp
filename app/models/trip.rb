class Trip < ApplicationRecord

    def self.weekly_summary
        stats = Trip.where("delivery_date >= ?", current_week).pluck("SUM(price), SUM(distance)")
        return {
            :total_distance => "#{stats[0][1]/1000}km",
            :total_price => "#{stats[0][0].round(2)}PLN"
        }
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
