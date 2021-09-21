require 'uri'
require 'net/http'

# Below implementation is rather a naive one. 
# If I really wanted to complicate this I would probably use a queue system (like rabbitmq)
# to defer the request in time in case the Google API wasn't available while the trip was
# added. This way the user wouldn't notice the temporary problem with external system. 
# But, for the sake of current exercise I will just log errors.
class DistanceService
    def initialize
        @api_key = ENV['GOOGLE_MAPS_API_KEY']
    end

    def get_distance_between(start_address, end_address)

        response = ask_google(start_address, end_address)

        if got_valid_result?(response)
            Rails.logger.debug "Request to Google Maps API succeeded. Response: #{response}" 
            return first_result(response)["distance"]["value"]
        else
            Rails.logger.error "Request to Google Maps API failed. Response: #{response}"
            return nil
        end
    end

    private

    def ask_google(start_address, end_address)
        url = create_url(start_address, end_address)
        https = get_https(url)
        response = https.request(Net::HTTP::Get.new(url))
        return JSON.parse(response.read_body)
    end

    def create_url(start_address, end_address)
        return URI("https://maps.googleapis.com/maps/api/distancematrix/json?origins=#{start_address}&destinations=#{end_address}&key=#{@api_key}")
    end

    def get_https(url)
        https = Net::HTTP.new(url.host, url.port)
        https.use_ssl = true
        return https
    end
    
    def got_valid_result?(response)
        response["status"] == "OK" and first_result(response)["status"] == "OK"
    end

    def first_result(response)
        response["rows"][0]["elements"][0]
    end
end