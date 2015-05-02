class OrdersController < ApplicationController
  def new
  end

  def create
  end

  def show
    @order = Order.find(params[:id])
    @tickets = @order.tickets || 3.times { Ticket.new }
  end
end
