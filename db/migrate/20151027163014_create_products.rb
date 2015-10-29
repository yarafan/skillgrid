class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :title
      t.text :description
      t.attachment :image
      t.references :user, null: false, index: true
      t.timestamps null: false
    end
  end
end
