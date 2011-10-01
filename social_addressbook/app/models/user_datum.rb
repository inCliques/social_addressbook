class UserDatum < ActiveRecord::Base
 attr_accessible :name, :value

  belongs_to :user
  belongs_to :data_type

  validates_presence_of :user
  validates_presence_of :data_type
  before_update :unique_name_update, :do_not_save_verified_data
  before_create :unique_name_create
  before_destroy :keep_name
  validate :no_empty_value

  def self.name_options
    return Hash["Email" => ['Personal', 'Work'],
                "Viadeo" => ['ProfileURL'],
                "Twitter" => ['Public', 'Private'],
                "Phone" => ['Personal', 'Work', 'Mobile', 'Fax'], 
                "Address" => ['Personal', 'Work'], 
                "Name" => []] 
  end

  def do_not_save_verified_data
    if self.verified
      errors[:base] << "Can not change verified data."
      return  false
    else
      return true
    end
  end

  def unique_name_update
    return unique_name(1)
  end

  def unique_name_create
    return unique_name(0)
  end

  def unique_name(nb)
    if self.data_type.name=='Name'
      name_id = DataType.first( :conditions => { :name => 'Name' } ).id
      if self.user.user_data.find(:all, :conditions => { :data_type_id => name_id }).count>nb
        errors[:base] << "Can only create one name."
        return  false
      end
    end
    return true
  end

  def keep_name
    if self.data_type.name=='Name'
      errors[:base] << "Can not delete name."
      return  false
    end
  end

  def no_empty_value
    if (self.value.nil? or self.value.empty?)
      errors[:base] << "Can not have emtpy value."
      return false
    else
      return true
    end
  end

end
