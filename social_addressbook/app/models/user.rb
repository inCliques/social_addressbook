class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :phone_number, :name

  has_many :groups_users, :dependent => :destroy
  has_many :groups, :through => :groups_users
  has_many :owners, :class_name => "Groups"
  has_and_belongs_to_many :roles

  after_create :import_cliques


  def import_cliques
    # If this user already exists as offline user, import all cliques 
    OfflineUser.where(:email => self.email).each do |offline_user|
      offline_user.groups.each do |group|  
        GroupsUser.create(:user => self, :group => group)
      end
      offline_user.destroy
    end

  end

  def role?(role)
    return !!self.roles.find_by_name(role.to_s.camelize)
  end

end
