class AddProToProducts < ActiveRecord::Migration
  def change
    add_column :products, :pro, :boolean, default: false
    add_column :products, :shop_title, :string
  end
end
