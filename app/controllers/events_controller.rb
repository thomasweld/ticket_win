
class EventsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]
  before_filter :set_event, only: [:show, :edit, :update, :destroy]
  before_filter :ensure_host_setup, only: [:new]

  def index
    @events = Event.all
  end

  def show
  end

  def new
    @event = Event.new
  end

  def edit
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
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_event
      @event = Event.find(params[:id])
    end

    def ensure_host_setup
      if current_user.host_enabled? && current_user.host.nil?
        session[:return_to] = new_event_path
        return redirect_to new_host_path
      end
    end

    def event_params
      params.require(:event).permit(:start_date, :end_date, :title, :description, :user_id, :image, :ticket_id, :ticket_price, :ticket_quantity, :vip_ticket_price, :vip_ticket_quantity, :vip_ticket_id, :sku_array)
    end
end
