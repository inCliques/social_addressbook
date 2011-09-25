class OfflineUser < ActiveRecord::Base
  has_many :groups_offline_users
  has_many :groups, :through => :groups_offline_users
  has_many :owners, :class_name => "Groups"
end
