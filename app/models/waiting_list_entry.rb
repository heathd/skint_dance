class WaitingListEntry < ActiveRecord::Base
  extend Forwardable
  belongs_to :reservation

  belongs_to :pre_reservation
  validates_presence_of :pre_reservation_id

  delegate [:name, :email] => :reservation

  def self.in_resource_category(resource_category)
    where(resource_category: resource_category)
  end

  def self.sleeping
    where(resource_category: :sleeping)
  end
end