class AddEarningsDataToLocation < ActiveRecord::Migration[5.0]
  def change
    remove_column :locations, :crime_rate
    add_column :locations, :crime_rate, :integer
    add_column :locations, :earnings, :integer
  end
end
