class OfflineUserDatum < ActiveRecord::Base
  attr_accessible :name, :value

  belongs_to :offline_user
  belongs_to :data_type

  validates_presence_of :offline_user
  validates_presence_of :data_type
  validate :no_empty_value

  def no_empty_value
    if (self.value.nil? or self.value.empty?)
      errors[:base] << "Can not have emtpy value."
      return false
    else
      return true
    end
  end

end
