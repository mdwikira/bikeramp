require 'date'

class Api::Stats::StatsController < ApplicationController
    def weekly
        render json: Trip.weekly_summary.to_json, status: :ok
    end

    def monthly
        render json: Trip.monthly_summary.to_json, status: :ok
    end
end