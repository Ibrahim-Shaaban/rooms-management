class CreateReservations < ActiveRecord::Migration[7.0]
  def change
    create_table :reservations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :room, null: false, foreign_key: true
      t.datetime :start_date
      t.datetime :end_date

      t.timestamps
    end

    add_index :reservations, [:user_id, :room_id, :start_date]
  end
end
