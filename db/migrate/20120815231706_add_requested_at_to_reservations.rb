class AddRequestedAtToReservations < ActiveRecord::Migration
  def change
    rename_column :reservations, :created_at, :requested_at
  end
end
