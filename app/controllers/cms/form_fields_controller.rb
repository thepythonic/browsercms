module Cms
  class FormFieldsController < Cms::BaseController

    def new

    end

    def create
      field = FormField.new(form_field_params)
      if field.save
        render :json => field
      end
    end

    def form_field_params()
      params.require(:form_field).permit(FormField.permitted_params)
    end
  end
end