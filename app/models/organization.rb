class Organization < ActiveRecord::Base
  has_many :events
  has_many :members, class_name: 'User'
  has_one :owner, class_name: 'User', foreign_key: 'owner_org_id'
end
