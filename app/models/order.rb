# == Schema Information
#
# Table name: orders
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  event_id        :integer
#  redemption_code :string
#  delivery_email  :string
#

class Order < ActiveRecord::Base
  belongs_to :user
  has_many :tickets

  after_initialize :provision_redemption_code, unless: :persisted?

  def self.create_from_preorder(order_params)
    order = nil
    self.transaction do
      order = self.create(order_params)
      order.tickets.each(&:lock_for_order!)
    end
    order
  end

  def total
    tickets.map(&:price).reduce(:+)
  end

  def event
    begin
      tickets.first.tier.event
    rescue
      Event.new
    end
  end

  def status
    ticket_status = tickets.map(&:status).uniq
    if ticket_status.all? { |s| s == 'locked_for_order' }
      if self.created_at < 1.hour.ago
        :stale_purchase
      else
        :pending_purchase
      end
    elsif ticket_status.all? { |s| s == 'sold' }
      :completed
    else
      :mismatched_ticket_status
    end
  end

  private

  def provision_redemption_code
    return true if self.redemption_code
    loop do
      self.redemption_code = RedemptionCode.new.to_s
      break unless self.class.find_by(redemption_code: self.redemption_code)
    end
  end
end
