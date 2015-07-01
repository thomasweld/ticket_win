class TicketsController < ApplicationController
  def index
    @event = Event.find(index_params[:event_id])
    @tickets = @event.tickets.manageable
    authorize! :checkin, @tickets.first
    @placeholder = "SKU (#{@tickets.first.sku}) or email (test@example.com)"

    if params[:search]
      @tickets = Ticket.search(params[:search], @tickets).order("created_at DESC")
    end

  rescue CanCan::AccessDenied
    flash[:error] = "You do not have permission to perform this action."
    return redirect_to root_path
  end

  def update
    @ticket = Ticket.find(params[:id])
    return false unless @ticket.status == params[:status]

    @ticket.status = new_status(params[:status])

    if @ticket.save
      Log.create(
        object: 'Ticket',
        content: "Ticket ##{@ticket.id} updated to #{@ticket.status}",
        user_id: current_user.id
      )
    end

    respond_to do |format|
      format.js
    end
  end

  private

  def index_params
    params
  end

  def new_status(current)
    case current
    when 'sold'
      'checked_in'
    when 'checked_in'
      'sold'
    end
  end
end
