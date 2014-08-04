class AddPreReservationIdToWaitingListEntry < ActiveRecord::Migration
  def up
    add_column :waiting_list_entries, :pre_reservation_id, :integer
    add_index :waiting_list_entries, :pre_reservation_id
  end

  def down
    remove_column :waiting_list_entries, :pre_reservation_id
  end
end
