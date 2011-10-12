class CreateOfflineUsers < ActiveRecord::Migration
  def self.up
    create_table :offline_users do |t|
      t.string :name
      t.string :email
      t.string :phone_number

      t.timestamps
    end
  end

  def self.down
    drop_table :offline_users
  end
end
