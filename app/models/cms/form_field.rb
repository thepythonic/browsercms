module Cms
  class FormField < ActiveRecord::Base
    extend DefaultAccessible

    attr_accessor :edit_path
    before_create :assign_field_name

    def as_json(options={})
      super(:methods => [:edit_path])
    end

    # Return the form widget that should be used to render this field.
    #
    # @return [Symbol] A SimpleForm input mapping (i.e. :string, :text)
    def as
      case field_type
        when "text_field"
          :string
        when "text_area"
          :text
        else
          :string
      end
    end

    # Return options to be passed to a SimpleForm input.
    # @return [Hash]
    # @param [Hash] config
    # @option config [Boolean] :disabled If the field should be disabled.
    def options(config={})
      opts = {label: label}
      if field_type != "text_field"
        opts[:as] = self.as
      end
      if config[:disabled]
        opts[:disabled] = true
        opts[:readonly] = 'readonly'
      end
      opts
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