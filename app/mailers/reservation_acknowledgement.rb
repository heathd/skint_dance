class ReservationAcknowledgement < ActionMailer::Base
  default from: "Skint <skint@skintdance.org.uk>", reply_to: "skint.dance@gmail.com"

  def acknowledge(reservation)
    @reservation = reservation
    mail(to: email_address_with_name(reservation),
         bcc: ["skint.dance@gmail.com"],
         subject: subject
         )
  end

private
  def subject
    prefix = Rails.env.production? ? "" : "[TEST] "
    prefix + "Reservation successful, please pay now!"
  end

  def email_address_with_name(reservation)
    %{"#{reservation.name}" <#{reservation.email}>}
  end

  
end
