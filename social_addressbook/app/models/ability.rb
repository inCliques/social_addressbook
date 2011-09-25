class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user
 
    if user.role? :admin
      can :manage, :all
    elsif user.role? :customer
      can :create, Group
      can :read, Group do |group|
        group.try(:users).include?(user) 
      end
      can [:update, :invite, :invite_save, :destroy], Group do |group|
        group.try(:owner) == user
      end
    end
  end
end
