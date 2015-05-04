# == Schema Information
#
# Table name: tickets
#
#  id         :integer          not null, primary key
#  sku        :string           not null
#  status     :string           not null
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  tier_id    :integer
#  order_id   :integer
#

class Ticket < ActiveRecord::Base
  include ClassyEnum::ActiveRecord

  belongs_to :tier
  belongs_to :user
  belongs_to :order

  after_initialize :provision_sku, unless: :persisted?

  validates :sku, presence: true, uniqueness: true
  validates :tier, presence: true

  classy_enum_attr :status, class_name: 'TicketStatus', default: 'unsold'
  [ :unsold?, :sold?, :locked_for_order?, :locked_by_event_owner? ].each { |status_predicate| delegate status_predicate, to: :status }

  [ :price, :level, :name, :description, :event_id ].each { |attr| delegate attr, to: :tier }

  def lock_for_order!
    self.update_attributes(status: 'locked_for_order')
  end

  def user_email
    user.try(:email) || "user@example.com"
  end

  private

  def provision_sku
    return true if self.sku
    loop do
      self.sku = SKU.new(self).sku
      break unless self.class.find_by(sku: self.sku)
    end
  end
end
