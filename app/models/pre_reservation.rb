class PreReservation < ActiveRecord::Base
  attr_accessible :email, :name, :reference, :resource_category, :expires_at

  attr_accessor :how_many

  validates_presence_of :name, :email, :reference, :resource_category, :expires_at
  validates_email_format_of :email

  def waiting_list?
    false
  end

  def expired?
    Time.zone.now > expires_at
  end

  def used_by
    Reservation.where(reference: self.reference).first
  end
end
