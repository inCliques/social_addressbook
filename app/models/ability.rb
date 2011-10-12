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
      can :create, UserDatum
      can [:manage], UserDatum do |user_datum|
        user_datum.try(:user) == user
      end
    end
  end
end
