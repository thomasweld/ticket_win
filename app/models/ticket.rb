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
  belongs_to :holder, class_name: 'User'

  classy_enum_attr :status, class_name: 'TicketStatus', default: 'unsold'
  [ :unsold?, :sold?, :locked_for_purchase?, :locked_by_event_owner? ].each { |status_predicate| delegate status_predicate, to: :status }
end
