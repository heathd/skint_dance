# encoding: UTF-8
class Reservation < ActiveRecord::Base
  PAYMENT_METHODS = %w{paypal gocardless cheque}
  validates_presence_of :name, :email, :phone_number, :what_can_you_help_with
  validates_email_format_of :email
  validates :payment_method, inclusion: {in: PAYMENT_METHODS}
# paypal_full_standard
# paypal_full_concession
# paypal_nonsleeping_full
# paypal_nonsleeping_concession

  class TicketType < Struct.new(:name, :description, :price, :gocardless_url, :paypal_partial)
    def self.all
      types = []
      types << TicketType.new(
        "Full, standard", 
        "Full weekend with food and indoor camping, standard rate", 
        3000,
        "https://gocardless.com/pay/VXF4PVEE",
        "paypal_full_standard")
      types << TicketType.new(
        "Full, concession",
        "Full weekend with food and indoor camping, really skint",
        2500,
        "https://gocardless.com/pay/GZSJ4T37",
        "paypal_full_concession")
      types << TicketType.new(
        "Non-sleeping, full",
        "Full weekend with food but NO ACCOMODATION, standard rate",
        2000,
        "https://gocardless.com/pay/EJAX31PT",
        "paypal_nonsleeping_full")
      types << TicketType.new(
        "Non-sleeping, concession",
        "Full weekend with food but NO ACCOMODATION, really skint",
        1800,
        "https://gocardless.com/pay/YW453Y2X",
        "paypal_nonsleeping_concession")
    end

    def self.options
      all.map do |type|
        [type.option_label, type.name]
      end
    end

    def formatted_price
      "£#{price_pounds}.#{price_pence}"
    end

    def price_pounds
      (price / 100).to_i
    end

    def price_pence
      "%02d" % (price % 100)
    end

    def option_label
      "#{description} - #{formatted_price} (#{remaining_places} left)"
    end

    def remaining_places
      0
    end
  end

  validates :ticket_type, :inclusion => { :in => TicketType.all.map(&:name) }

  state_machine :state, :initial => :new do
    state :new
  end

  def ticket_type_object
    @ticket_type_object ||= TicketType.all.find {|t| t.name == ticket_type}
  end

  def gocardless_url
    ticket_type_object && ticket_type_object.gocardless_url
  end

  def paypal_partial
    ticket_type_object && ticket_type_object.paypal_partial
  end

  def self.make_reservation(params)
    require 'securerandom'
    reservation = Reservation.new(params.merge(state: "new"))
    reservation.reference = ::SecureRandom.hex(3)
    reservation.save
    if reservation.errors[:reference].any?
      reservation.reference = ::SecureRandom.hex(4)
      reservation.save
    end
    reservation
  end

  def payment_deadline
    created_at + if payment_method == 'cheque'
      2.weeks
    else
      1.week
    end
  end

  def formatted_price
    ticket_type_object && ticket_type_object.formatted_price
  end
end