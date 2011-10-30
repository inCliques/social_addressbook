class UserDatum < ActiveRecord::Base
 attr_accessible :name, :value

  belongs_to :user
  belongs_to :data_type

  validates_presence_of :user
  validates_presence_of :data_type
  before_update :update_only_unverified_data
  after_save :import_cliques_from_offline_users, :if => "self.verified"
  validate :no_empty_value

  def self.name_options
    return Hash["Email" => ['Personal', 'Work'],
                "Viadeo" => ['ProfileURL'],
                "Twitter" => ['Public', 'Private'],
                "Phone" => ['Personal', 'Work', 'Mobile', 'Fax'], 
                "Address" => ['Personal', 'Work'],
                "Skype" => ['Personal', 'Professional'],
                "Name" => []] 
  end

  def import_cliques_from_offline_users
    self.user.import_cliques
  end

  def update_only_unverified_data
    if self.verified
      errors[:base] << "Can not change verified data."
      return  false
    else
      return true
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
