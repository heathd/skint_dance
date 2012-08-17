class AddPaymentDueToReservation < ActiveRecord::Migration
  class Reservation < ActiveRecord::Base
    def set_payment_due!
      payment_due = requested_at + if payment_method == 'cheque'
        2.weeks
      else
        1.week
      end
      save
    end
  end

  def up
    add_column :reservations, :payment_due, :datetime
    Reservation.where(state: :reserved).each do |reservation|
      reservation.set_payment_due!
    end
  end

  def down
    remove_column :reservations, :payment_due
  end
end
