require "test_helper"

class TripTest < ActiveSupport::TestCase
  valid_prices = ["10", "10.2", "10.25"]
  invalid_prices = ["asdf", "a10.5", "50.9999"]

  valid_dates = ["2021-08-07"]
  invalid_dates = ["2222-22-22", "asdfg", "20ab12-10as-23xx"]

  valid_distances = ["1234", '60', "60.5"]
  invalid_distances = ["asdf", "", nil]

  setup do
    Timecop.freeze(Date.new(2020, 1, 3))
  end

  test "delivery_date, price and date must be present to save Trip" do
    valid_trip = Trip.new(price: valid_prices[0], delivery_date: valid_dates[0], distance: valid_distances[0])
    trip_with_no_price = Trip.new(price: nil, delivery_date: valid_dates[0], distance: valid_distances[0])
    trip_with_no_delivery_date = Trip.new(price: valid_prices[0], delivery_date: nil, distance: valid_distances[0])
    trip_with_no_distance = Trip.new(price: valid_prices[0], delivery_date: valid_dates[0], distance: nil)

    assert valid_trip.save
    assert_not trip_with_no_price.save
    assert_not trip_with_no_delivery_date.save
    assert_not trip_with_no_distance.save
  end

  test "won't save Trip with invalid price" do
    for price in invalid_prices
      trip = Trip.new(price: price, delivery_date: valid_dates[0], distance: valid_distances[0])
      assert_not trip.save
    end
  end

  test "won't save Trip with invalid date" do
    for date in invalid_dates
      trip = Trip.new(price: valid_prices[0], delivery_date: date, distance: valid_distances[0])
      assert_not trip.save
    end
  end

  
  test "won't save Trip with invalid distance" do
    for distance in invalid_distances
      trip = Trip.new(price: valid_prices[0], delivery_date: valid_dates[0], distance: distance)
      assert_not trip.save, "Distance is invalid but trip was saved : #{distance}"
    end
  end

  test "will return valid weekly summary" do
    summary = Trip.weekly_summary
    # assertion based on trips fixture context
    assert_equal summary, {:total_distance => "6km", :total_price => "40PLN"}
  end

  test "will return valid monthly summary" do
    summary = Trip.monthly_summary
    # assertion based on trips fixture context
    assert_equal summary, [{:day=>"January, 2nd", :total_distance=>"3km", :avg_ride=>"2km", :avg_price=>"10.0PLN"}, {:day=>"January, 3rd", :total_distance=>"3km", :avg_ride=>"2km", :avg_price=>"10.0PLN"}]
  end

end
