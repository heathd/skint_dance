class DayTicketOrdersController < ApplicationController
  before_filter :find_day_ticket_order, only: :show

  def index
    redirect_to action: :closed
    @day_ticket_order = DayTicketOrder.new(ticket_types: TicketType.day)
  end

  def create
    redirect_to action: :closed
    @day_ticket_order = RESERVATION_MANAGER.place_day_ticket_order(params[:day_ticket_order])
    if @day_ticket_order.valid?
      DayTicketOrderAcknowledgement.acknowledge(@day_ticket_order).deliver
      redirect_to @day_ticket_order
    else
      render :index
    end
  end

  def show
  end

private
  def find_day_ticket_order
    @day_ticket_order = DayTicketOrder.find_by_reference(params[:id])
    if !@day_ticket_order
      flash[:error] = "Sorry, can't find that reservation"
    end
  end
end
  
