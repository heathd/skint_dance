# encoding: UTF-8
class Reservation < ActiveRecord::Base
  extend Forwardable
  delegate [:gocardless_url, :paypal_partial, :formatted_price, :resource_category] => :ticket_type

  belongs_to :ticket_type
  has_many :waiting_list_entries, dependent: :destroy
  has_many :gocardless_bills

  PAYMENT_METHODS = %w{paypal gocardless cheque}
  validates_presence_of :name, :email, :phone_number, :what_can_you_help_with, :reference
  validates_email_format_of :email
  validates :payment_method, inclusion: {in: PAYMENT_METHODS}
  validates_presence_of :ticket_type
  validate :valid_pre_reservation!

  attr_accessor :want_waiting_list

  state_machine :state, :initial => :new do
    state :new
    state :reserved
    state :waiting_list
    state :paid do
      transition to: :payment_cleared, on: :payment_cleared
    end
    state :payment_cleared
    state :cancelled
    state :payment_on_arrival

    event :reserve do
      transition [:new, :waiting_list] => :reserved
    end

    event :cancel do
      transition [:new, :reserved, :waiting_list] => :cancelled
    end

    after_transition any => :cancelled, :do => :remove_from_waiting_list
  end

  def self.reserved
    where(state: [:reserved, :paid, :payment_cleared, :payment_on_arrival])
  end

  def self.cancelled
    where(state: :cancelled)
  end

  def remove_from_waiting_list
    waiting_list_entries.destroy_all
  end
  
  def add_to_waiting_list(waiting_list_resource_category)
    connection.transaction do
      self.state = "waiting_list" if waiting_list_resource_category == self.resource_category
      # todo, add pre_reservation id to waiting list entry
      waiting_list_entries.create(
        resource_category: waiting_list_resource_category, 
        added_at: requested_at,
        pre_reservation: self.pre_reservation)
      save!
    end
  end

  def pre_reservation
    PreReservation.find_by_reference(self.reference)
  end

  def self.waiting_for(resource_category)
    joins(:waiting_list_entries).where("waiting_list_entries.resource_category" => resource_category)
  end

  def self.in_resource_category(resource_category)
    joins(:ticket_type).where("ticket_types.resource_category" => resource_category)
  end

  def reserve(clock = DateTime)
    super
    set_payment_due!(clock)
  end

  def set_payment_due!(clock = DateTime)
    self.payment_due = clock.now + if payment_method == 'cheque'
      2.weeks
    else
      1.week
    end
    save
  end

  def total_paid_in_pence
    gocardless_bills.sum(&:amount_in_pence)
  end

  def balance
    ticket_type && (ticket_type.price_in_pence - total_paid_in_pence)
  end

  def valid_pre_reservation!
    pre_reservation = PreReservation.find_by_reference(self.reference)
    unless pre_reservation
      errors[:reference] << "no matching pre-reservation found with reference #{self.reference}"
      return
    end
    if pre_reservation.used_by && pre_reservation.used_by != self
      errors[:reference] << "invalid, pre-reservation already used for another reservation"
      return
    end
    if pre_reservation.resource_category != ticket_type.resource_category
      errors[:ticket_type] << "invalid, pre-reservation only allows '#{pre_reservation.resource_category.humanize}' ticket types"
      return
    end
  end
end