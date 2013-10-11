module Cms
  class FormFieldsController < Cms::BaseController

    layout false

    def new
      @field = Cms::FormField.new(label: 'Untitled', field_type: 'text_field')
    end

    def preview
      @form = Cms::Form.new
    end

    def create
      field = FormField.new(form_field_params)
      if field.save
        include_edit_path_in_json(field)
        render json: field
      end
    end

    def edit
      @field = FormField.find(params[:id])
      render :new
    end

    def update
      field = FormField.find(params[:id])
      if field.update form_field_params
        include_edit_path_in_json(field)
        render json: field
      else
        render text: "Fail", status: 500
      end
    end

    protected

    # For UI to update for subsequent editing.
    def include_edit_path_in_json(field)
      field.edit_path = cms.edit_form_field_path(field)
    end

    def form_field_params()
      params.require(:form_field).permit(FormField.permitted_params)
    end
  end
end