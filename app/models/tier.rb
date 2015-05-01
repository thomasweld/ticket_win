# == Schema Information
#
# Table name: tiers
#
#  id          :integer          not null, primary key
#  level       :integer
#  name        :string
#  description :text
#  price       :integer
#  event_id    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Tier < ActiveRecord::Base
  belongs_to :event
  has_many :tickets, dependent: :destroy

  validates :level, uniqueness: { scope: :event_id }
end
