class CreateRooms < ActiveRecord::Migration[7.0]
  def change
    create_table :rooms do |t|
      t.string :number
      t.integer :room_type
      t.float :price_per_night

      t.timestamps
    end

    add_index :rooms, :number, unique: true

  end
end
