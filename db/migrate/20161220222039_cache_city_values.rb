class CacheCityValues < ActiveRecord::Migration[5.0]
  def change
    add_column :locations, :city_id, :string
    add_column :locations, :crime_rate, :string
    rename_column :locations, :city, :city_name
  end
end
