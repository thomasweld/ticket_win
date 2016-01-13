class OrdersController < ApplicationController
  include ActionView::Helpers::NumberHelper

  before_action :parse_preorder!, only: :create
  before_action :safe_referrer, only: :checkout

  def create
    @order = Order.create_from_preorder(user: current_user, tickets: requested_tickets)
    path = @order.valid? ? checkout_order_path(@order) : :back
    redirect_to path
  end

  def checkout
    @order = Order.find(params[:id])
    @email = current_user.try(:email)
    @line_items = line_items
    @coupon = @order.coupon
    @total = total

    gon.push(stripe_pub_key: ENV['STRIPE_PUB_KEY'], free_order: @order.free?)
  end

  def update
    @order = Order.find(params[:id])
    if @order.free?
      @order.tickets.each { |t| t.sell! to: current_user }
      @order.update_attribute(:delivery_email, params[:email])
      OrderMailer.order_confirmation_email(@order).deliver_later
      path = redeem_order_path(@order.redemption_code)
    else
      path = handle_payment
    end
    redirect_to path
  end

  def promo
    promo = Coupon.find_by(code: params[:promo_code])

    if promo && !promo.redeemed?
      order = Order.find(params[:id])
      order.coupon = promo
      promo.redeemed_at = Time.zone.now

      if order.save && promo.save
        flash[:notice] = 'Coupon successfully applied'
      else
        flash[:error] = 'There was a problem applying your coupon'
      end

    elsif promo && promo.redeemed?
      flash[:error] = 'This coupon has already been redeemed'
    else
      flash[:error] = 'Invalid coupon or promo code'
    end

    redirect_to checkout_order_path
  end

  def show
    @order = Order.find(params[:id])
    redirect_to redeem_order_path(@order.redemption_code)
  end

  def redeem
    @order = Order.find_by(redemption_code: params[:redemption_code])
    @line_items = line_items
    @email = @order.delivery_email || current_user.try(:email)
    @total = total
    @event = @order.event
    @tickets = @order.tickets
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

  def line_items
    items = []
    event = @order.tickets.first.tier.event
    event_title = event.title
    location = event.location
    event_date = event.start_date.to_formatted_s(:long)
    tiers = @order.tickets.map(&:tier).uniq.sort_by(&:level)
    tiers.each do |tier|
      qty = @order.tickets.select { |t| t.tier_id == tier.id }.count
      items << {
        description: "#{event_title} @ #{location} - #{tier.name}\n#{event_date}",
        price: tier.price_in_dollars,
        quantity: qty,
        total: ?$ + (tier.price_in_dollars.gsub(/\$/,'').to_i * qty).to_s + '.00'
      }
    end
    items
  end

  def total
    number_to_currency(@order.total / 100)
  end

  def handle_payment
    charge_hash = {
      amount: @order.total,
      source_token: params[:stripe_token],
      destination_user: @order.event.user
    }
    charge = StripeCharge.new(@order, charge_hash).execute!
    path = nil
    if charge.is_a? Stripe::CardError
      flash[:error] = "Your payment was unsuccessful. Please try again."
      path = :back
    elsif charge.is_a? Stripe::InvalidRequestError
      flash[:error] = "This event is temporarily unavailable."
      Rails.logger.fatal "Stripe::InvalidRequestError for order #{@order.id}"
      Rails.logger.fatal "Error: #{charge}"
      path = :back
    elsif charge[:paid] && charge[:status] == 'succeeded'
      @order.tickets.each { |t| t.sell! to: current_user }
      @order.update(
        delivery_email: params[:email],
        last4:          charge[:source][:last4],
        charge_brand:   charge[:source][:brand]
      )
      OrderMailer.order_confirmation_email(@order).deliver_later
      path = redeem_order_path(@order.redemption_code)
    else
      flash[:error] = "Something went wrong with your payment. Please try again."
      path = :back
    end
    path
  end

  def safe_referrer
    return true unless Rails.env.production?
    if current_user.try(:admin?) || request.referrer =~ /tcktwn\.com/
      true
    else
      redirect_to root_path and return
    end
  end
end
