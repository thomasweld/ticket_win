
class EventsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]

  def index
    @events = Event.all
  end

  def show
    @event = Event.find(params[:id])
  end

  def new
    @event = Event.new(user: current_user)
    gon.push(
      stripe_authorized: @event.user.stripe_authorized?,
      stripe_message: session.delete(:stripe)
    )
  end

  def edit
    @event = Event.find(params[:id])
    gon.push(
      stripe_authorized: @event.user.stripe_authorized?,
      stripe_message: session.delete(:stripe)
    )
  end

  def create
    @event = Event.new(event_params)
    @event.user = current_user

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @event = Event.find(params[:id])
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def event_params
    params.require(:event).permit(:start_date, :end_date, :title, :description, :user_id, :image, :ticket_id, :ticket_price, :ticket_quantity, :vip_ticket_price, :vip_ticket_quantity, :vip_ticket_id, :sku_array)
  end
end
