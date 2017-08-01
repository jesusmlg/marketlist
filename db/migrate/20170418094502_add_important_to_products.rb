class AddImportantToProducts < ActiveRecord::Migration[4.2]
  def change
    add_column :products, :important, :boolean
  end
end
