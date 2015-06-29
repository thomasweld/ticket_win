# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  admin                  :boolean          default(FALSE), not null
#  locked                 :boolean          default(FALSE), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  created_at             :datetime
#  updated_at             :datetime
#  image_file_name        :string
#  image_content_type     :string
#  image_file_size        :integer
#  image_updated_at       :datetime
#  stripe_user_id         :string
#  stripe_account_type    :string
#  stripe_pub_key         :string
#  stripe_secret_key      :string
#  stripe_authorized_at   :datetime
#  role                   :string
#  organization_id        :integer
#  owner_org_id           :integer
#

class User < ActiveRecord::Base

  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable, :confirmable

  paginates_per 100

  after_initialize :set_defaults

  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  belongs_to :organization
  has_many :events
  has_many :tickets

  ROLES = %i[guest user member owner admin]

  def role?(base_role)
    ROLES.index(base_role.to_sym) <= ROLES.index(self.role.to_sym)
  end

  def stripe_authorized?
    self.stripe_user_id && self.stripe_authorized_at
  end

  def deauthorize_stripe!
    self.update_attributes(
      stripe_user_id: nil, stripe_account_type: nil,
      stripe_pub_key: nil, stripe_secret_key: nil,
      stripe_authorized_at: nil
    )
  end

  def self.paged(page_number)
    order(admin: :desc, email: :asc).page page_number
  end

  def self.search_and_order(search, page_number)
    if search
      where("email LIKE ?", "%#{search.downcase}%").order(
      admin: :desc, email: :asc
      ).page page_number
    else
      order(admin: :desc, email: :asc).page page_number
    end
  end

  def self.last_signups(count)
    order(created_at: :desc).limit(count).select("id","email","created_at")
  end

  def self.last_signins(count)
    order(last_sign_in_at:
    :desc).limit(count).select("id","email","last_sign_in_at")
  end

  def self.users_count
    where("admin = ? AND locked = ?",false,false).count
  end

  def set_defaults
    self.role ||= 'guest'
  end
end
