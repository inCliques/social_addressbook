class CreateGroupsUsers < ActiveRecord::Migration
  def self.up
    create_table :groups_users do |t|
      t.integer :user_id
      t.integer :group_id
      t.boolean :permission_email
      t.boolean :permission_phone_number
      t.boolean :confirmed

      t.timestamps
    end
  end

  def self.down
    drop_table :groups_users
  end
end
