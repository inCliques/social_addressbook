class DataType < ActiveRecord::Base
  has_many :user_data, :dependent => :destroy

end
