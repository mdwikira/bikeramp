class ChangePrice < ActiveRecord::Migration[6.1]
  def change
    change_column :trips, :price, :decimal, :precision => 8, :scale => 2
  end
end
