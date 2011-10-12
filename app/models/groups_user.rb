class GroupsUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :group

  validate :no_duplicates
  validates_presence_of :user
  validates_presence_of :group


  def no_duplicates
    if GroupsUser.where(:user_id => self.user.id, :group_id => self.group.id).count != 0
      errors[:base] << "You are already a member of this clique."
      return  false
    end
    true
  end

end
