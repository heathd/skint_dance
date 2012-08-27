class ReservationsController < ApplicationController
  before_filter :find_reservation, only: :success

  def index
    @reservation = Reservation.new
  end

  def create
    reservation_params = params[:reservation]
    @reservation = RESERVATION_MANAGER.make_reservation(reservation_params)
    if @reservation.valid?
      redirect_to reservation_success_path(@reservation.reference)
    else
      render :index
    end
  end

  def success
    if @reservation.waiting_list?
      render :waiting_list
    end
  end

private
  def find_reservation
    @reservation = Reservation.find_by_reference(params[:reservation_id])
    if !@reservation
      flash[:error] = "Sorry, can't find that reservation"
      redirect_to :index
    end
  end
end
