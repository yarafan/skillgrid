class AddSurnameAvatarPhotoBdateShopToUsers < ActiveRecord::Migration
  def change
    add_column :users, :surname, :string
    add_attachment :users, :avatar
    add_attachment :users, :photo
    add_column :users, :birthday, :date
    add_column :users, :shop, :string
  end
end
