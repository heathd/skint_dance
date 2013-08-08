class ReservationAcknowledgement < ActionMailer::Base
  default from: "Skint <skint.dance@gmail.com>"

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
    prefix + "Skint reservation order acknowledgement"
  end

  def email_address_with_name(reservation)
    %{"#{reservation.name}" <#{reservation.email}>}
  end

  
end
