module Cms
  class FormField < ActiveRecord::Base
    extend DefaultAccessible

    attr_accessor :edit_path
    before_create :assign_field_name

    def as_json(options={})
      super(:methods => [:edit_path])
    end

    # Name is assigned when the Field is created, and should not be changed afterwords.
    # Otherwise existing entries will not display their data correctly.
    #
    # FormField#name is used for input fields. I.e. <%= f.input field.name %>
    def assign_field_name
      self.name = label.parameterize.underscore.to_sym
    end

    # Don't allow name to be set via UI.
    def self.permitted_params
      super - [:name]
    end
  end
end