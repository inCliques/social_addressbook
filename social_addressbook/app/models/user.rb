class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :phone_number, :name

  has_many :groups_users, :dependent => :destroy
  has_many :groups, :through => :groups_users
  has_many :owners, :class_name => "Groups"
  has_and_belongs_to_many :roles
  has_many :user_data, :dependent => :destroy

  after_create :set_default_role, :create_default_data_fields # TODO: import_clique should be called after_verification instead after_create

  def name
    name_data_type_id = DataType.first(:conditions => { :name => 'Name' }).id
    self.user_data.first(:conditions => {:data_type_id => name_data_type_id}).value
  end

  def find_datum_of_type(type_name)
    data_type_id = DataType.first(:conditions => { :name => type_name }).id
    self.user_data.find(:all, :conditions => {:data_type_id => data_type_id})
  end

  def find_verified_datum_of_type(type_name)
    data_type_id = DataType.first(:conditions => { :name => type_name }).id
    self.user_data.find(:all, :conditions => {:data_type_id => data_type_id, :verified => true})
  end

  def has_datum_of_type(type_name)
    data_type_id = DataType.first(:conditions => { :name => type_name }).id
    self.user_data.find(:all, :conditions => {:data_type_id => data_type_id}).count > 0
  end

  def has_verified_datum_of_type(type_name)
    data_type_id = DataType.first(:conditions => { :name => type_name }).id
    self.user_data.find(:all, :conditions => {:data_type_id => data_type_id, :verified => true}).count > 0
  end

  # Checks for every verified datum of this person if there is an associated offline profile and imports its cliques.
  def import_cliques
    verified_data = self.user_data.find(:all, :conditions => {:verified => true})

    verified_data.each do |datum| 
      # Check if there is an offline user with this datum
      offline_datum = OfflineUserDatum.first(:conditions => {:value => datum.value, :data_type_id => datum.data_type_id})

      while not offline_datum.nil?
        # We just found an associated offline user, so let's import its cliques
        groups = offline_datum.offline_user.groups
        
        groups.each do |group| 
          # Add the user as a member of the clique
          GroupsUser.create(:user_id => self.id, :group_id => group.id) 
        end

        # We do not need the offline user any more. Deleting it will also get rid of the OfflineData and OfflineGroupsUser table entries.
        offline_datum.offline_user.destroy
        
        offline_datum = OfflineUserDatum.first(:conditions => {:value => datum.value, :data_type_id => datum.data_type_id})
      end

    end
  end

  def set_default_role
    RolesUser.create(:user_id => self.id, :role_id => Role.where(:name => 'customer').first.id)
  end

  def role?(role)
    return self.roles.find_by_name(role).try(:name) == role.to_s
  end

  def create_default_data_fields
    user_datum = UserDatum.new(:value => 'Edit my name')
    user_datum.user_id = self.id
    user_datum.data_type_id = DataType.where(:name => 'Name').first.id
    user_datum.verified = false
    user_datum.save

    user_datum = UserDatum.new(:name => UserDatum.name_options()['Email'][0], :value => self.email)
    user_datum.user_id = self.id
    user_datum.data_type_id = DataType.where(:name => 'Email').first.id
    user_datum.verified = true
    user_datum.save

  end

end
