module Cms
  class FormResponse < ActiveRecord::Base
    store :data_columns
    belongs_to :form, class_name: 'Cms::Form'

    after_initialize :add_field_accessors

    # Add a single field accessor to the current instance of the object. (I.e. not shared with others)
    def add_store_accessor(field_name)
      singleton_class.class_eval { store_accessor :data_columns, field_name}
    end

    # Define accessors for all fields on the backing form.
    def add_field_accessors
      return unless form
      form.field_names.each do |field_name|
        add_store_accessor(field_name)
      end
    end

    #class << self
    #
    #  # Links this response to a specific Cms::Form.
    #  #
    #  # @param [Cms::Form] form
    #  # @return [Cms::FormResponse] Response with accessors for each field on the given form.
    #  def for_form(form)
    #    response = Cms::FormResponse.new
    #    response.form = form
    #
    #    # Adds all the fields to the FormResponse class. This allows the form below to be generated.
    #    # @todo - Issue: This modifies the FormResponse class for all cases, which might have undesirable side effects.
    #    form.field_names.each do |field_name|
    #      response.class.store_accessor :data_columns, field_name
    #    end
    #
    #    response
    #  end
    #end

    def permitted_params
      form.field_names
    end
  end
end