class UserDatum < ActiveRecord::Base
  belongs_to :user
  belongs_to :data_type
end
