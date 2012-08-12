class CreateReservation < ActiveRecord::Migration
  def up
    create_table :reservations do |t|
      t.string :reference, unique: true
      t.string :state
      t.string :ticket_type
      t.string :payment_method
      t.string :payment_reference
      t.string :name
      t.string :email
      t.string :phone_number
      t.text :what_can_you_help_with
      t.boolean :participate_in_fare_pool
      t.string :dietary_requirements
      t.text :comments
      t.timestamps
    end
    add_index(:reservations, :reference, unique: true)
  end

  def down
    remove_index :reservations, :reference
    drop_table :reservations
  end
end
