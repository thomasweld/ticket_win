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

  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  classy_enum_attr :status, class_name: 'EventStatus', default: 'pending_approval'
  [ :pending_approval?, :live?, :expired? ].each { |status_predicate| delegate status_predicate, to: :status }
end
