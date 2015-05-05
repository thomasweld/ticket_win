class StripeCharge

  def initialize(order = nil, charge)
    @order = order || Order.new
    @amount = charge[:amount]
    @currency = charge[:currency] || 'usd'
    @source_token = charge[:source_token]
    @destination_user = charge[:destination_user]
    @app_fee_percent = charge[:app_fee_percent] || ENV['STRIPE_APP_FEE_PERCENT'].to_f
  end

  def execute!
    ::Stripe::Charge.create(
      amount: @amount,
      currency: @currency,
      source: @source_token,
      destination: destination,
      description: "TCKTWN order id ##{@order.id}",
      application_fee: app_fee
    )
  rescue => e
    e
  end

  private

  def app_fee
    (@amount * @app_fee_percent).to_i
  end

  def destination
    @destination_user.stripe_user_id
  end
end
