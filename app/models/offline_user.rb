class OfflineUser < ActiveRecord::Base
  has_many :groups_offline_users, :dependent => :destroy
  has_many :groups, :through => :groups_offline_users

  has_many :offline_user_data, :dependent => :destroy

  def find_datum_of_type(type_name)
    data_type_id = DataType.first(:conditions => { :name => type_name }).id
    self.offline_user_data.find(:all, :conditions => {:data_type_id => data_type_id})
  end

  def has_datum_of_type(type_name)
    data_type_id = DataType.first(:conditions => { :name => type_name }).id
    self.offline_user_data.find(:all, :conditions => {:data_type_id => data_type_id}).count > 0
  end

end
