class PaymentReminder < ActionMailer::Base
  default from: "Skint <skint.dance@gmail.com>"

  def remind(reservation)
    @reservation = reservation
    reservation.set_payment_due! unless reservation.payment_due
    mail(to: email_address_with_name(reservation),
         bcc: ["skint.dance@gmail.com"],
         subject: subject
         )
  end

  def self.remind_unpaid
    RESERVATION_MANAGER.unpaid.each do |reservation|
      puts "Sending reminder to #{reservation.name} #{reservation.email}"
      remind(reservation).deliver
    end
  end

private
  def subject
    prefix = Rails.env.production? ? "" : "[TEST] "
    prefix + "Skint reservation - payment due"
  end

  def email_address_with_name(reservation)
    %{"#{reservation.name}" <#{reservation.email}>}
  end

  
end
