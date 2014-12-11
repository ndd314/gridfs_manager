class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    can :manage, Folder, :owner => { :id => user.id }
    can :manage, GridfsFile, :owner => { :id => user.id }
  end
end
