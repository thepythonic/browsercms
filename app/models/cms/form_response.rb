module Cms
  class FormResponse < ActiveRecord::Base
    store :data_columns
    attr_accessor :form

    class << self

      # Links this response to a specific Cms::Form.
      #
      # @param [Cms::Form] form
      # @return [Cms::FormResponse] Response with accessors for each field on the given form.
      def for_form(form)
        response = Cms::FormResponse.new
        response.form = form

        # Adds all the fields to the FormResponse class. This allows the form below to be generated.
        # @todo - Issue: This modifies the FormResponse class for all cases, which might have undesirable side effects.
        form.field_names.each do |field_name|
          response.class.store_accessor :data_columns, field_name
        end

        response
      end
    end

    def permitted_params
      form.field_names
    end
  end
end