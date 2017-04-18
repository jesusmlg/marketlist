class AddImportantToProducts < ActiveRecord::Migration
  def change
    add_column :products, :important, :boolean
  end
end
