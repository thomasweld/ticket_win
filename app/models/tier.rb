# == Schema Information
#
# Table name: tiers
#
#  id                    :integer          not null, primary key
#  level                 :integer
#  name                  :string
#  description           :text
#  price                 :integer
#  event_id              :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  unprovisioned_tickets :integer          default(0)
#

class Tier < ActiveRecord::Base
  belongs_to :event
  has_many :tickets, dependent: :destroy

  validates :level, uniqueness: { scope: :event_id }
  [:title, :start_date, :end_date, :location].each { |attr| delegate attr, to: :event }

  def available_tickets
    tickets.where(status: 'unsold')
  end

  def available_for_purchase
    available_tickets.count
  end

  def price_in_dollars
    "$#{self.price / 100}.00"
  end

  def provision_tickets
    self.transaction do
      self.unprovisioned_tickets.times do
        unprov = self.unprovisioned_tickets
        Ticket.create(tier: self)
        self.update_attribute(:unprovisioned_tickets, unprov - 1)
      end
    end
  end
end
