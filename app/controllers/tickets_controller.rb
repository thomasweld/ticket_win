class TicketsController < ApplicationController
  def index
    @event = Event.find(index_params[:event_id])
    @tickets = @event.tickets.manageable
    if params[:search]
      @users = Ticket.search(params[:search]).order("created_at DESC")
    else
      @users = Ticket.all.order('created_at DESC')
    end
  end

  def search
  end

  def update
  end

  private

  def index_params
    params
  end
end
