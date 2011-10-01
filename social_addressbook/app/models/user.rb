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

  after_create :import_cliques, :set_default_role, :create_default_data_fields


  def import_cliques
    # If this user already exists as offline user, import all cliques 
    OfflineUser.where(:email => self.email).each do |offline_user|
      offline_user.groups.each do |group|  
        GroupsUser.create(:user => self, :group => group)
      end
      offline_user.destroy
    end
  end

  def set_default_role
    RolesUser.create(:user_id => self.id, :role_id => Role.where(:name => 'customer').first.id)
  end

  def role?(role)
    return self.roles.find_by_name(role).try(:name) == role.to_s
  end

  def create_default_data_fields
    UserDatum.create(:user_id => self.id, :data_type_id => DataType.where(:name => 'Name').first.id, :name => DataType.where(:name => 'Name').first.name, :value => 'Edit my name')
  end

end
