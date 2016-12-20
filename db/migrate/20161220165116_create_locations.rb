class CreateLocations < ActiveRecord::Migration[5.0]
  def change
    create_table :locations do |t|
      t.text :address
      t.decimal :lat
      t.decimal :long

      t.timestamps
    end
  end
end
