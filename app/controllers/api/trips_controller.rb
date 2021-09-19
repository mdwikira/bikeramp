require 'date'
require 'uri'
require 'net/http'

class Api::TripsController < ApplicationController
    def create
        params.require([:start_address, :end_address, :price, :date])
        start_address = params[:start_address]
        end_address = params[:end_address]
        price = params[:price].to_f
        date = DateTime.parse(params[:date])
        @trip = Trip.create(price: price, delivery_date: date, distance: get_distance_between(start_address, end_address))
        render json: @trip, status: :ok
    end

    private

    def get_distance_between(start_address, end_address)
        api_key = ENV['GOOGLE_MAPS_API_KEY']
        url = URI("https://maps.googleapis.com/maps/api/distancematrix/json?origins=#{start_address}&destinations=#{end_address}&key=#{api_key}")
        https = Net::HTTP.new(url.host, url.port)
        https.use_ssl = true
        response = https.request(Net::HTTP::Get.new(url))
        JSON.parse(response.read_body)["rows"][0]["elements"][0]["distance"]["value"]
    end
    
end
