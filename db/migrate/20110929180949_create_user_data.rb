class CreateUserData < ActiveRecord::Migration
  def self.up
    create_table :user_data do |t|
      t.integer :user_id 
      t.integer :data_type_id # The type of this data. This is mainly used to sort the user data by types.
      t.string :name # A custom name for this data. While type.name might be "Phone", user_data.name might be more specific and chosen by the user e.g. "Work phone". 
      t.string :value # The value of the type, e.g. "+49(0)176/20032645"
      t.boolean :verified # True if the user data is verified. 

      t.timestamps
    end
  end

  def self.down
    drop_table :user_data
  end
end
