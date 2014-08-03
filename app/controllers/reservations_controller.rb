class ReservationsController < ApplicationController
  before_filter :find_pre_reservation, only: [:index, :create]
  before_filter :find_reservation, only: :success

  def index
    @reservation = Reservation.new
    @reservation.name = @pre_reservation.name
    @reservation.reference = @pre_reservation.reference
    @reservation.email = @pre_reservation.email
  end

  def create
    @reservation = RESERVATION_MANAGER.make_reservation(@pre_reservation, params[:reservation])
    if @reservation.errors.empty?
      ReservationAcknowledgement.acknowledge(@reservation).deliver unless @reservation.waiting_list?
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

  def find_pre_reservation
    @pre_reservation = PreReservation.find_by_reference(params[:pre_reservation])
    if @pre_reservation.nil?
      flash[:error] = "Sorry, can't find that reservation"
      redirect_to pre_reservations_path
    elsif @pre_reservation.expired?
      flash[:error] = "Sorry, your pre-reservation expired at #{I18n.l(@pre_reservation.expires_at)}"
      redirect_to pre_reservations_path
    end
  end

  def ticket_type_options
    TicketType.weekend.select {|t| t.resource_category == @pre_reservation.resource_category }
  end
  helper_method :ticket_type_options
end
