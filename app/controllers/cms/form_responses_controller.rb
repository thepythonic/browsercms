module Cms
  class FormResponsesController < Cms::BaseController
    def create
      form = Cms::Form.find(params[:form_id])
      @form_response = Cms::FormResponse.for_form(form)
      @form_response.attributes = response_params(@form_response)
      if @form_response.save!
          render :show
      else
        render text: 'Fail'
      end
    end

    def response_params(form_response)
      params.require(:form_response).permit(form_response.permitted_params)
    end
  end
end