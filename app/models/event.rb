class Event < ActiveRecord::Base
  include ClassyEnum::ActiveRecord

  belongs_to :user
  has_many :tickets, dependent: :destroy

  classy_enum_attr :status, class_name: 'EventStatus', default: 'pending_approval'
  [ :pending_approval?, :live?, :expired? ].each { |status_predicate| delegate status_predicate, to: :status }
end
