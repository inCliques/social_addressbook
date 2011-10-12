class CreateDataTypes < ActiveRecord::Migration
  def self.up
    create_table :data_types do |t|
      t.string :name # The default name of the type. This could be Phone, Email, Twitter, ...

      t.timestamps
    end
  end

  def self.down
    drop_table :data_types
  end
end
