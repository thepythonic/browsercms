module Cms
  class FormResponsesController < Cms::BaseController

    helper_method :content_type, :new_block_path
    helper Cms::ContentBlockHelper

    # Same behavior as ContentBlockController#index
    def index
      form = Cms::Form.where(id: params[:id]).first
      @blocks = Cms::FormResponse.where(form_id: params[:id]).paginate({page: params[:page], order: params[:order]})
      @content_type = FauxContentType.new(form)
      render 'cms/content_block/index'
    end

    def create
      form = Cms::Form.find(params[:form_id])
      @form_response = Cms::FormResponse.new(form: form)
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

    protected

    def new_block_path(block, options={})
      cms.new_form_response_path(options)
    end


    # Allows Entries to be displayed using same view as Content Blocks.
    class FauxContentType < Cms::ContentType
      def initialize(form)
        @form = form
        self.name = 'Cms::FormResponse'
      end

      def display_name
        'Entry'
      end

      def columns_for_index
        cols = @form.fields.collect do |field|
          {:label => field.label, :method => field.name, :order => field.name}
        end
        cols
      end
    end

    def content_type
      @content_type
    end
  end
end