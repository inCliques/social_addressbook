class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.string :name
      t.integer :owner_id
      t.string :color
      t.boolean :private, :default => true

      t.timestamps
    end
  end

  def self.down
    drop_table :groups
  end
end
