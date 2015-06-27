class TicketsController < ApplicationController
  def index
    @event = Event.find(index_params[:event_id])
    @tickets = @event.tickets.manageable
  end

  def update
  end

  private

  def index_params
    params.require(:event_id).permit!
  end
end
