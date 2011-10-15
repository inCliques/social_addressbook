class OfflineUserDatum < ActiveRecord::Base
  attr_accessible :name, :value

  belongs_to :offline_user
  belongs_to :data_type

  validates_presence_of :offline_user
  validates_presence_of :data_type, :presence => true
  validates :value, :length => { :minimum => 3 }, :presence => true


end
