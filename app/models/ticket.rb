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
  %i[unsold? sold? locked_for_order?
  locked_by_event_owner? checked_in?].each do |status_predicate|
    delegate status_predicate, to: :status
  end

  %i[price level name description event_id].each do |attr|
    delegate attr, to: :tier
  end

  def self.search(query, pre_scope=nil)
    sku = query.gsub(/ /, '').upcase.strip
    email = query.downcase.strip

    pre_scope.joins(:order)
      .where("sku like ? OR orders.delivery_email like ?", "%#{sku}%", "%#{email}%")
  end

  delegate :delivery_email, to: :order

  def self.manageable
    where(status: %w[sold checked_in])
  end

  def lock_for_order!
    self.update_attributes(status: 'locked_for_order')
  end

  def sell!(to: nil)
    self.update_attributes(status: 'sold', user: user)
  end

  def user_email
    user.try(:email)
  end

  def formatted_sku
    self.sku.reverse.scan(/.{1,3}/).join(' ').reverse
  end

  def formatted_price
    "$#{(self.price / 100)}.00"
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
