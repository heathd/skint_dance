class CreatePreReservations < ActiveRecord::Migration
  def change
    create_table :pre_reservations do |t|
      t.string :reference
      t.string :email
      t.string :name
      t.string :resource_category
      t.datetime :expires_at

      t.timestamps
    end
  end
end
