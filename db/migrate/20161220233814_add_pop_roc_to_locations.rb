class AddPopRocToLocations < ActiveRecord::Migration[5.0]
  def change
    add_column :locations, :pop_change, :decimal
  end
end
