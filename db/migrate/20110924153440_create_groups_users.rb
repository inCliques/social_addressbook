class CreateGroupsUsers < ActiveRecord::Migration
  def self.up
    create_table :groups_users do |t|
      t.integer :user_id
      t.integer :group_id
      t.boolean :confirmed # A flag indicating if the user has confirmed to be part of the group

      t.timestamps
    end
  end

  def self.down
    drop_table :groups_users
  end
end
