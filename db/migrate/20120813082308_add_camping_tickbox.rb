class AddCampingTickbox < ActiveRecord::Migration
  def change
    add_column :reservations, :camping, :boolean
  end
end
