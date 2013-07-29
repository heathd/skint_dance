class AddTravellingFromToReservation < ActiveRecord::Migration
  def change
    add_column :reservations, :travelling_from, :string
  end
end
