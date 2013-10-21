# This is a sample content type that mimics how content blocks are generated with project status.
class Dummy::Product < ActiveRecord::Base
  acts_as_content_block
  content_module :testing
  self.table_name = :products

  belongs_to_category

  is_addressable path: '/products', template: 'subpage'

  has_attachment :photo_1
  has_attachment :photo_2

end
