# == Schema Information
#
# Table name: tickets
#
#  id               :integer          not null, primary key
#  sku              :string           not null
#  tier             :integer          not null
#  tier_name        :string
#  tier_description :text
#  price            :integer          not null
#  status           :string           not null
#  event_id         :integer
#  user_id          :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Ticket < ActiveRecord::Base
  include ClassyEnum::ActiveRecord

  belongs_to :event
  belongs_to :user

  after_initialize :provision_sku, unless: :persisted?

  validates :sku, presence: true, uniqueness: true
  validates :event, presence: true

  classy_enum_attr :status, class_name: 'TicketStatus', default: 'unsold'
  [ :unsold?, :sold?, :locked_for_purchase?, :locked_by_event_owner? ].each { |status_predicate| delegate status_predicate, to: :status }

  private

  def provision_sku
    return true if self.sku
    loop do
      self.sku = SKU.new(self).sku
      break unless Ticket.find_by(sku: self.sku)
    end
  end
end
