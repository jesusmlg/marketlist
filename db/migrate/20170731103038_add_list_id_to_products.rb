class AddListIdToProducts < ActiveRecord::Migration[4.2]
  def change
    add_column :products, :list_id, :integer
  end
end
