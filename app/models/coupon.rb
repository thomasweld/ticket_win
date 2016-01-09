class Coupon < ActiveRecord::Base
  belongs_to :event
  belongs_to :order

  def self.provision_for_event(event=nil, count:, amount:)
    raise 'Coupons already provisioned for this event' if event && event.coupons.any?
    provision(event, count, amount)
  end

  def self.provision_for_event!(event, count:, amount:)
    provision(event, count, amount)
  end

  def self.provision(event, count, amount)
    count.times do |i|
      begin
        create(
          event:  event,
          code:   Code.new.code,
          amount: amount
        )
      rescue ActiveRecord::RecordNotUnique
        retry
      end
    end
  end

  def redeemed?
    !!redeemed_at
  end

  def description
    "$#{amount/100} OFF COUPON - 2016 TicketWin Promotions\n<code>#{code}</code>"
  end
end
