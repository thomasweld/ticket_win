
class EventsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]
  # load_and_authorize_resource

  def index
    @events = Event.approved
  end

  def show
    @event = Event.find(params[:id])
    @tiers = @event.tiers.sort_by(&:level)
    @order = Order.new
  end

  def new
    @event = Event.new(user: current_user)
    5.times { @event.tiers.build }
    gon.push(stripe_authorized: @event.user.stripe_authorized?, stripe_message: session.delete(:stripe))
  end

  def create
    @event = Event.new(event_params)
    @event.user = current_user

    if @event.save
      @event.tiers.each(&:provision_tickets)
      redirect_to @event, notice: 'Your event was created and all tickets provisioned.'
    else
      render :new
    end
  end

  def edit
    @event = Event.find(params[:id])
    gon.push(stripe_authorized: @event.user.stripe_authorized?, stripe_message: session.delete(:stripe), editAction: true)
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
    params.require(:event).permit(:start_date, :end_date, :title, :description, :image,
      :location, tiers_attributes: [:level, :name, :description, :price, :unprovisioned_tickets])
  end
end
