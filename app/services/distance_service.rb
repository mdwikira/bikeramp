require 'uri'
require 'net/http'

class DistanceService
    def initialize
        @api_key = ENV['GOOGLE_MAPS_API_KEY']
    end

    def get_distance_between(start_address, end_address)
        url = create_url(start_address, end_address)
        https = get_https(url)
        response = https.request(Net::HTTP::Get.new(url))
        body = JSON.parse(response.read_body)
        if body["status"] == "OK"
            return body["rows"][0]["elements"][0]["distance"]["value"]
        else
            return nil
        end
    end

    private

    def create_url(start_address, end_address)
        url = URI("https://maps.googleapis.com/maps/api/distancematrix/json?origins=#{start_address}&destinations=#{end_address}&key=#{@api_key}")
    end

    def get_https(url)
        https = Net::HTTP.new(url.host, url.port)
        https.use_ssl = true
        return https
    end
    
end