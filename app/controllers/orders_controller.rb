class OrdersController < ApplicationController

  before_action :parse_preorder!, only: :create

  def create
    @order = Order.create_with_tickets(user: current_user, tickets: requested_tickets)
  end

  def update
  end

  def show
    @order = Order.find(params[:id])
    @tickets = @order.tickets || 3.times { Ticket.new }
  end

  private

  def parse_preorder!
    @tiers = []
    params.permit!.each do |param|
      if param.first == "event_id"
        @event = Event.find(param.last)
      elsif param.first =~ /tickets_tier/
        tier_id = param.first.split(/_/).last.to_i
        @tiers << [ Tier.find(tier_id), param.last ]
      end
    end
  end

  def requested_tickets
    requested_tickets = []
    @tiers.each do |tier|
      requested_tickets << tier.first.available_tickets.first(tier.last)
    end
    requested_tickets.flatten
  end
end
