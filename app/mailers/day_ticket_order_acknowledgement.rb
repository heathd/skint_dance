class DayTicketOrderAcknowledgement < ActionMailer::Base
  default from: "Skint <skint.dance@gmail.com>"

  def acknowledge(day_ticket_order)
    @day_ticket_order = day_ticket_order
    mail(to: email_address_with_name(day_ticket_order),
         bcc: ["skint.dance@gmail.com"],
         subject: subject
         )
  end

private
  def subject
    prefix = Rails.env.production? ? "" : "[TEST] "
    prefix + "Skint day ticket order acknowledgement"
  end

  def email_address_with_name(day_ticket_order)
    %{"#{day_ticket_order.name}" <#{day_ticket_order.email}>}
  end

  
end
