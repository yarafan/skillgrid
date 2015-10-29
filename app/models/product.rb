class Product < ActiveRecord::Base
  belongs_to :user
  has_attached_file :image, styles: { thumb: '100x100', large: '500x500' }
  validates_attachment_content_type :image, content_type: /\Aimage/
  validates :title, presence: true
  validates :description, presence: true
end
