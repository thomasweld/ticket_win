# == Schema Information
#
# Table name: events
#
#  id          :integer          not null, primary key
#  title       :string           not null
#  description :text
#  start_date  :datetime
#  end_date    :datetime
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  status      :string
#

class Event < ActiveRecord::Base
  include ClassyEnum::ActiveRecord

  belongs_to :owner, class_name: 'User'
  has_many :tickets, dependent: :destroy

  classy_enum_attr :status, class_name: 'EventStatus', default: 'pending_approval'
  [ :pending_approval?, :live?, :expired? ].each { |status_predicate| delegate status_predicate, to: :status }
end
