# == Schema Information
#
# Table name: organizations
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Organization < ActiveRecord::Base
  has_many :events
  has_many :members, class_name: 'User'
  has_one :owner, class_name: 'User', foreign_key: 'owner_org_id'

  def to_param
    [id, name.parameterize].join(?-)
  end
end
