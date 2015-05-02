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
