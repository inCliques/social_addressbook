class CreateOfflineUserData < ActiveRecord::Migration
  def self.up
    create_table :offline_user_data do |t|
      t.integer :offline_user_id
      t.integer :data_type_id
      t.string :name
      t.string :value

      t.timestamps
    end
  end

  def self.down
    drop_table :offline_user_data
  end
end
