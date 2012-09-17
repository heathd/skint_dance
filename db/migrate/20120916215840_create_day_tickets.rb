class CreateDayTickets < ActiveRecord::Migration
  def up
    create_table :day_ticket_orders do |t|
      t.string :reference, unique: true
      t.string :state
      t.string :name
      t.string :email
      t.string :phone_number
      t.text :what_can_you_help_with
      t.boolean :camping
      t.text :comments
      t.timestamps
    end
    create_table :day_ticket_order_ticket_types do |t|
      t.integer :day_ticket_order_id
      t.integer :ticket_type_id
    end
    add_index(:day_ticket_orders, :reference, unique: true)
  end

  def down
    drop_table :day_ticket_order_ticket_types
    remove_index :day_ticket_orders, :reference
    drop_table :day_ticket_orders
  end
end
