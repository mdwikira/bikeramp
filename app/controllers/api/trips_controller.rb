require 'date'

class Api::TripsController < ApplicationController

    def create
        price = params[:price]
        date = params[:date]
        distance = DistanceService.new().get_distance_between(
            params[:start_address],
            params[:end_address]
        )

        trip = Trip.new(price: price, delivery_date: date, distance: distance)
        if trip.valid?
            trip.save
            render json: trip, status: :ok
        else
            render json: {"errors" => prepare_errors_for_user(trip.errors)}, status: :bad_request
        end
    end

    private 

    def prepare_errors_for_user(errors)
        out = []
        if errors[:price_before_type_cast]
            out.append("Price is missing or invalid format.")
        end
        if errors[:delivery_date]
            out.append("Date is invalid.")
        end
        if errors[:distance]
            out.append("Couldn't calculate distance. Please check that given addresses are correct.")
        end
        return out
    end
    
end
