class CreateTrips < ActiveRecord::Migration[6.1]
  def change
    create_table :trips do |t|
      t.decimal :price
      t.integer :distance

      t.timestamps
    end
  end
end
