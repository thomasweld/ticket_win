# == Schema Information
#
# Table name: events
#
#  id                 :integer          not null, primary key
#  title              :string           not null
#  description        :text
#  start_date         :datetime
#  end_date           :datetime
#  user_id            :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  status             :string
#  image_file_name    :string
#  image_content_type :string
#  image_file_size    :integer
#  image_updated_at   :datetime
#

class Event < ActiveRecord::Base
  include ClassyEnum::ActiveRecord

  belongs_to :user
  has_many :tickets, dependent: :destroy
  accepts_nested_attributes_for :tickets

  before_create :set_defaults

  has_attached_file :image, :styles => { :medium => "600x900>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  classy_enum_attr :status, class_name: 'EventStatus', default: 'pending_approval'
  [ :pending_approval?, :live?, :expired? ].each { |status_predicate| delegate status_predicate, to: :status }

  private

  def set_defaults
    self.start_date ||= Time.now
    self.end_date ||= self.start_date + 4.hours
  end
end
