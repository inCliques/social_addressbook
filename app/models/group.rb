class Group < ActiveRecord::Base
  has_many :groups_users
  has_many :users, :through => :groups_users
  has_many :groups_offline_users
  has_many :offline_users, :through => :groups_offline_users
  belongs_to :owner, :class_name => "User" 

  validates :name, :presence => true, :length => { :minimum => 3 }
end
