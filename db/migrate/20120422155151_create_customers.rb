class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :name, :null => false, :unique => true

      t.timestamps
    end
  end
end
