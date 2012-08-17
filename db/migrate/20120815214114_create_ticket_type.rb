require_relative "../seeds/ticket_types"
class CreateTicketType < ActiveRecord::Migration
  class TicketType < ActiveRecord::Base; end

  def up
    create_table :ticket_types do |t|
      t.string :name
      t.string :description
      t.integer :price_in_pence
      t.string :gocardless_url
      t.string :paypal_partial
      t.string :resource_category
    end
    seed_ticket_types
    add_column :reservations, :ticket_type_id, :integer
    execute "update reservations set ticket_type_id=(select id from ticket_types where ticket_types.name=reservations.ticket_type)"
    remove_column :reservations, :ticket_type
  end

  def down
    add_column :reservations, :ticket_type, :string
    execute "update reservations set ticket_type=(select name from ticket_types where ticket_types.id=reservations.ticket_type_id)"
    remove_column :reservations, :ticket_type_id
    drop_table :ticket_types
  end
end
