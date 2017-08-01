class CreateProducts < ActiveRecord::Migration[4.2] 
  def change
    create_table :products do |t|
      t.string :name
      t.string :user
      t.integer :comprado, default: 0

      t.timestamps
    end
  end
end
