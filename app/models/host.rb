# == Schema Information
#
# Table name: hosts
#
#  id                         :integer          not null, primary key
#  stripe_account_id          :integer
#  first_name                 :string
#  last_name                  :string
#  legal_entity_type          :string
#  address                    :string
#  birth_date                 :datetime
#  ssn_last_4                 :integer
#  stripe_tos_acceptance_date :datetime
#  stripe_tos_acceptance_ip   :string
#  user_id                    :integer
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#

class Host < ActiveRecord::Base
  belongs_to :user
end
