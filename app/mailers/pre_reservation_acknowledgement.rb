class PreReservationAcknowledgement < ActionMailer::Base
  default from: "Skint <skint@skintdance.org.uk>", reply_to: "skint.dance@gmail.com"

  def acknowledge(pre_reservation)
    @pre_reservation = pre_reservation
    mail(to: email_address_with_name(pre_reservation),
         bcc: ["skint.dance@gmail.com"],
         subject: subject
         )
  end

private
  def subject
    prefix = Rails.env.production? ? "" : "[TEST] "
    prefix + "Skint pre-reservation acknowledgement"
  end

  def email_address_with_name(pre_reservation)
    %{"#{pre_reservation.name}" <#{pre_reservation.email}>}
  end

  
end
