require 'test_helper'

class TripsControllerTest < ActionDispatch::IntegrationTest
    setup do
        mock_distance_service_with_valid_result
    end

    test "should save trip" do
        DistanceService.stub :new, @distance_service_mock do
            # when
            post api_create_trip_url, params: {"start_address":"Szmaragdowa 40, Lublin, Polska", "end_address":"Onyksowa 5, Lublin, Polska", "price": "12.50", "date":"2021-09-12"}, as: :json

            # then
            created_id = JSON.parse(@response.body)["id"]
            assert Trip.find(created_id)
            assert_response :created
        end
    end

    test "should not save trip with invalid date" do
        DistanceService.stub :new, @distance_service_mock do
            # when
            post api_create_trip_url, params: {"start_address":"Szmaragdowa 40, Lublin, Polska", "end_address":"Onyksowa 5, Lublin, Polska", "price": "12.50", "date":"invalid"}, as: :json

            # then
            errors = JSON.parse(@response.body)["errors"]
            assert errors.any? {|err| err.match /Date is invalid/}
            assert_response :bad_request
        end
    end

    test "should not save trip with invalid price" do
        DistanceService.stub :new, @distance_service_mock do
            # when
            post api_create_trip_url, params: {"start_address":"Szmaragdowa 40, Lublin, Polska", "end_address":"Onyksowa 5, Lublin, Polska", "price": "invalid", "date":"2020-02-02"}, as: :json

            # then
            errors = JSON.parse(@response.body)["errors"]
            assert errors.any? {|err| err.match /Price is missing or invalid format/}
            assert_response :bad_request
        end
    end

    test "should not save trip with invalid distance" do
        # given
        mock_distance_service_with_invalid_result

        DistanceService.stub :new, @distance_service_mock do
            # when
            post api_create_trip_url, params: {"start_address":"asdf", "end_address":"Onyksowa 5, Lublin, Polska", "price": "12.50", "date":"2020-03-05"}, as: :json

            # then
            errors = JSON.parse(@response.body)["errors"]
            assert errors.any? {|err| err.match /Couldn't calculate distance/}
            assert_response :bad_request
        end
    end

    private

    def mock_distance_service_with_valid_result()
        @distance_service_mock = Minitest::Mock.new
        def @distance_service_mock.get_distance_between(start_address, end_address)
            123
        end
    end

    def mock_distance_service_with_invalid_result()
        @distance_service_mock = Minitest::Mock.new
        def @distance_service_mock.get_distance_between(start_address, end_address)
            nil
        end
    end
end