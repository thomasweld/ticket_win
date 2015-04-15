class Ticket < ActiveRecord::Base
  belongs_to :event
  belongs_to :holder, class_name: 'User'
end
