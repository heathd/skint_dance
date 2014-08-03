class PreReservationsController < ApplicationController
  before_filter :find_reservation, only: :success
  before_filter :captcha_valid?, only: :create

  def index
  end

  def create
    pre_reservation_params = params[:pre_reservation]
    pre_reservation_params[:how_many] = pre_reservation_params[:how_many].to_i
    @pre_reservations = RESERVATION_MANAGER.pre_reserve(pre_reservation_params)
    if @pre_reservations.all? { |p| p.errors.empty? }
      @pre_reservations.each do |pre_reservation|
        PreReservationAcknowledgement.acknowledge(pre_reservation).deliver
      end
      redirect_to pre_reservation_success_path(@pre_reservations.first.reference, references: @pre_reservations.map(&:reference))
    else
      @pre_reservation = @pre_reservations.first
      render :index
    end
  end

  def success
    @pre_reservations = params[:references].map do |ref|
      PreReservation.find_by_reference(ref)
    end

    if @pre_reservations.size == 1
      render "success_one_place"
    elsif @pre_reservations.size == 2
      render "success_two_places"
    else
      redirect_to pre_reservations_path
    end
    # if @pre_reservation.waiting_list?
    #   render :waiting_list
    # end
  end

private
  def find_reservation
    @pre_reservation = PreReservation.find_by_reference(params[:pre_reservation_id])
    if !@pre_reservation
      redirect_to pre_reservations_path, :notice => "Sorry, can't find that reservation"
    end
  end

  def captcha_valid?
    if ! verify_recaptcha
      pre_reservation.valid?
      pre_reservation.errors.delete(:reference)
      pre_reservation.errors.delete(:expires_at)

      pre_reservation.errors[:base] << "Spam control check failed"
      render :index
    end
  end

  def pre_reservation
    @pre_reservation ||= PreReservation.new(params[:pre_reservation])
  end

  helper_method :pre_reservation
end
