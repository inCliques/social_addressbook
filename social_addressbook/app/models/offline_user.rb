class OfflineUser < ActiveRecord::Base
  has_many :groups_offline_users, :dependent => :destroy
  has_many :groups, :through => :groups_offline_users
  has_many :owners, :class_name => "Groups"

  has_many :user_data, :dependent => :destroy

  after_create :create_default_data_fields

  def create_default_data_fields
    UserDatum.create(:user_id => self.id, :type_id => DataType.where(:name => 'Phone').first.id, :name => DataType.where(:name => 'Phone').first.name)
    UserDatum.create(:user_id => self.id, :type_id => DataType.where(:name => 'Twitter').first.id, :name => DataType.where(:name => 'Twitter').first.name)
  end

end
