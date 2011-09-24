class GroupsOfflineUser < ActiveRecord::Base
  belongs_to :offline_user
  belongs_to :group


  validate :no_duplicates
  validates_presence_of :offline_user
  validates_presence_of :group


  def no_duplicates
    if GroupsOfflineUser.where(:offline_user_id => self.offline_user.id, :group_id => self.group.id).count != 0
      errors[:base] << "This person is already a member of this clique."
      return  false
    end
    true
  end
end
