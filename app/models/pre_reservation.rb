class PreReservation < ActiveRecord::Base
  attr_accessible :email, :name, :reference, :resource_category, :expires_at

  has_one :reservation, foreign_key: :reference, primary_key: :reference

  attr_accessor :how_many

  validates_presence_of :name, :email, :reference, :resource_category, :expires_at
  validates_email_format_of :email

  def self.unredeemed
    where("not exists(select * from reservations where reservations.reference=pre_reservations.reference)")
  end

  def self.unexpired(clock = Time.zone)
    where("expires_at > ?", clock.now)
  end


  def waiting_list?
    
  end

  def expired?
    Time.zone.now > expires_at
  end

  def used_by
    Reservation.where(reference: self.reference).first
  end
end
