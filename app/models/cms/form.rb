module Cms
  class Form < ActiveRecord::Base
    acts_as_content_block
    content_module :forms

    has_many :fields, class_name: 'Cms::FormField'
    has_many :entries, class_name: 'Cms::FormEntry'

    def field_names
      fields.collect {|f| f.name }
    end

    # Provides a sample Entry for the form.
    # This allows us to use SimpleForm to layout out elements but ignore the input when the form submits.
    def new_entry
      Cms::Entry.new(form: self)
    end
  end
end
