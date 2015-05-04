# == Schema Information
#
# Table name: orders
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Order < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  has_many :tickets

  def self.create_with_tickets(order_params)
    self.transaction do
      order = self.create(order_params)
      order.tickets.each(&:lock_for_order!)
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
end
