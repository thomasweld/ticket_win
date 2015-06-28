class TicketsController < ApplicationController
  def index
    @event = Event.find(index_params[:event_id])
    @tickets = @event.tickets.manageable
    @placeholder = "SKU (#{@tickets.first.sku}) or email (test@example.com)"
    authorize! :checkin, @tickets.first

    if params[:search]
      @tickets = Ticket.search(params[:search], @tickets).order("created_at DESC")
    end
  end

  def update
  end

  private

  def index_params
    params
  end
end
