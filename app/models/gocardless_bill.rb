class GocardlessBill < ActiveRecord::Base
  belongs_to :reservation

  def find_matching_reservation
    Reservation.reserved.find_by_email(user_email)
  end

  def amount_in_pence
    (BigDecimal.new(amount) * BigDecimal.new("100")).to_i
  end
end