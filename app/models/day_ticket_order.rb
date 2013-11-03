class DayTicketOrder < ActiveRecord::Base
  has_many :day_ticket_order_ticket_types
  has_many :ticket_types, through: :day_ticket_order_ticket_types

  validates_presence_of :name, :email, :phone_number, :what_can_you_help_with
  validates_email_format_of :email
  validates :ticket_types, presence: true

  def self.find(param)
    find_by_reference!(param)
  end

  def balance
    ticket_types.inject(0) {|sum, t| sum + t.price_in_pence}
  end

  def to_param
    reference
  end

  def gocardless_url
    payment_links = {
      1 => "https://gocardless.com/pay/JSSMR63B",
      2 => "https://gocardless.com/pay/BYT81FZ8",
      3 => "https://gocardless.com/pay/STQA306E",
      4 => "https://gocardless.com/pay/EAVJFYSQ",
      5 => "https://gocardless.com/pay/N6W16AKA",
      6 => "https://gocardless.com/pay/020FZJE1"
    }
    payment_links[ticket_types.count]
  end
end


