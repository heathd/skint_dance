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

    def self.find_by_name(name)
      TicketType.all.find {|t| t.name == name}
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
      remaining_text = if remaining_places > 0
        "#{remaining_places} left"
      else
        "waiting list"
      end
      "#{description} - #{formatted_price} (#{remaining_text})"
    end

    def category
      name.include?("Non-sleeping") ? :non_sleeping : :sleeping
    end

    def self.reserved_places
      aggregates = {
        sleeping: 0,
        non_sleeping: 0
      }
      counts = Reservation.group(:ticket_type).select("ticket_type, count(*) as count")
      counts.each do |record|
        type = TicketType.find_by_name(record.ticket_type)
        aggregates[type.category] += record.count
      end
      aggregates
    end

    def remaining_places
      available = {
        sleeping: 65,
        non_sleeping: 35
      }
      available[category] - TicketType.reserved_places[category]
    end
  end

  validates :ticket_type, :inclusion => { :in => TicketType.all.map(&:name) }

  state_machine :state, :initial => :new do
    state :new
    state :reserved
    state :waiting_list
    state :paid

    event :reserve do
      transition [:new, :waiting_list] => :reserved
    end

    event :add_to_waiting_list do
      transition [:new] => :waiting_list
    end
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
    reservation.reference = ::SecureRandom.urlsafe_base64(3)
    reservation.save
    if reservation.errors[:reference].any?
      reservation.reference = ::SecureRandom.urlsafe_base64(4)
      reservation.save!
    end

    if reservation.valid? 
      if reservation.ticket_type_object.remaining_places > 0
        reservation.reserve
      else
        reservation.add_to_waiting_list
      end
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