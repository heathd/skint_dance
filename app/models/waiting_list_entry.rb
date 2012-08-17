class WaitingListEntry < ActiveRecord::Base
  extend Forwardable
  belongs_to :reservation

  delegate [:name, :email] => :reservation


  def self.in_resource_category(resource_category)
    where(resource_category: resource_category)
  end

  def self.sleeping
    where(resource_category: :sleeping)
  end
end