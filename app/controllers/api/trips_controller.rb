require 'date'

class Api::TripsController < ApplicationController

    def create
        params.require([:start_address, :end_address, :price, :date])

        price = params[:price].to_f
        date = DateTime.parse(params[:date])
        distance = DistanceService.new().get_distance_between(
            params[:start_address],
            params[:end_address]
        )

        unless distance.nil?
            @trip = Trip.create(price: price, delivery_date: date, distance: distance)
            render json: @trip, status: :ok
        else
            render json: {"message": "Can't create trip. Make sure that all parameters are valid."}, status: :bad_request
        end
        
    end
    
end
