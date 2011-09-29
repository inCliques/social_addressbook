class UserDatum < ActiveRecord::Base
  belongs_to :user
  belongs_to :data_type

  validates_presence_of :user
  validates_presence_of :data_type
#  validate :no_name

  def no_name
    if self.data_type.name='Name'
      errors[:base] << "Can not create another name."
      return  false
    end
    true
  end

end
