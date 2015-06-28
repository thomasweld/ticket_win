class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user || User.new
    alias_action [:read, :update, :search], to: :checkin

    if user.role? :admin
      admins
    elsif user.role? :owner
      owners
    elsif user.role? :member
      members
    elsif user.role? :user
      users
    else
      guests
    end
  end

  private

  def admins
    can :manage, :all
  end

  def owners
  end

  def members
    can :checkin, Ticket, tier:
      { event: { organization_id: user.organization.id } }
  end

  def users
    can :read, Event, status: 'live'
  end

  def guests
  end
end
