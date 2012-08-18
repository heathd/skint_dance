namespace :payment_reminder do
  desc "Send reminder emails for every unpaid reservation"
  task :send_all => :environment do
    PaymentReminder.remind_unpaid
  end
end