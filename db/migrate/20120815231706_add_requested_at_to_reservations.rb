class AddRequestedAtToReservations < ActiveRecord::Migration
  def change
    rename_column :reservations, :created_at, :requested_at
    remove_column :reservations, :updated_at
  end
end
