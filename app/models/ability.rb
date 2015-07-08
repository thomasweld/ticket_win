class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(u)
    @user = u || User.new
    alias_action [:index, :show, :update, :search], to: :checkin

    can :edit, Event, user_id: user.id
    can :edit, Tier, tier: { event: { user_id: user.id } }

    case user.role.to_sym
    when :user
      can :read, Event, status: 'live'
    when :admin
      can :manage, :all
    when :owner
    when :member
      can :checkin, Ticket, tier: { event: { organization_id: user.organization.id } }
      can :read, Organization, id: user.organization.id
    else

    end
  end
end
