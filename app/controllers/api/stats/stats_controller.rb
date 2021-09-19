require 'date'

class Api::Stats::StatsController < ApplicationController
    def weekly
        render json: Trip.weekly_summary.to_json, status: :ok
    end

    def monthly
        render json: {"stub": "response"}, status: :ok
    end
end