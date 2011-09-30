class UserDatum < ActiveRecord::Base
  belongs_to :user
  belongs_to :data_type

  validates_presence_of :user
  validates_presence_of :data_type
  before_save :unique_name
  before_destroy :keep_name

  def unique_name
    if self.data_type.name=='Name'
      name_id = DataType.first( :conditions => { :name => 'Name' } ).id
      if self.user.user_data.find(:all, :conditions => { :data_type_id => name_id }).count>0
        errors[:base] << "Can only create one name."
        return  false
      end
    end
    return true
  end

  def keep_name
    if self.data_type.name='Name'
      errors[:base] << "Can not delete name."
      return  false
    end
  end

end
