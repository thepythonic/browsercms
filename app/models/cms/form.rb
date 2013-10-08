module Cms
  class Form < ActiveRecord::Base
    acts_as_content_block
    content_module :forms

    # For UI only
    attr_accessor :new_field, :sample_field

    has_many :fields, class_name: 'Cms::FormField'
    has_many :entries, class_name: 'Cms::FormResponse'

    def field_names
      fields.collect {|f| f.name }
    end
  end
end
