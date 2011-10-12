class CreateGroupsOfflineUsers < ActiveRecord::Migration
  def self.up
    create_table :groups_offline_users do |t|
      t.integer :offline_user_id
      t.integer :group_id
      t.boolean :confirmed

      t.timestamps
    end
  end

  def self.down
    drop_table :groups_offline_users
  end
end
