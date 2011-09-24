class Group < ActiveRecord::Base
  has_and_belongs_to_many :Users
  belongs_to :owner, :class_name => "User" 

end
