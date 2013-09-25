module Cms
  class Form < ActiveRecord::Base
    acts_as_content_block
    content_module :core

    has_many :fields, class_name: 'Cms::FormField'
  end
end
