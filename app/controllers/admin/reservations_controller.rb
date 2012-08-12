class Admin::ReservationsController < ApplicationController
  def index
    @reservations = Reservations.all
  end

  def show
  end

  def edit
  end

  def new
  end
end
