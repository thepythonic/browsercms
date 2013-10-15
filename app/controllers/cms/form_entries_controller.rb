module Cms
  class FormEntriesController < Cms::BaseController

    include ContentRenderingSupport

    helper_method :content_type, :new_block_path
    helper Cms::ContentBlockHelper

    allow_guests_to [:submit]

    # Handles public submission of a form.
    def submit
      find_form_and_populate_entry
      if @entry.save!
        if @form.show_text?
          show_content_as_page(@form)
          render layout: Cms::Form.layout
        else
          redirect_to @form.confirmation_redirect
        end
      else
        save_entry_failure
      end
    end

    # Same behavior as ContentBlockController#index
    def index
      form = Cms::Form.where(id: params[:id]).first
      @blocks = Cms::FormEntry.where(form_id: params[:id]).paginate({page: params[:page], order: params[:order]})
      @content_type = FauxContentType.new(form)

      # Shim for buttonbar
      @entry = Cms::FormEntry.new(form: form)

      render 'cms/content_block/index'
    end

    def edit
      @entry = Cms::FormEntry.find(params[:id])
    end

    def update
      @entry = Cms::FormEntry.find(params[:id])
      if @entry.update(entry_params(@entry))
        redirect_to form_entry_path(@entry)
      end
    end

    def show
      @entry = Cms::FormEntry.find(params[:id])
    end

    def new
      @entry = Cms::FormEntry.new(form_id: params[:form_id])
    end

    def create
      find_form_and_populate_entry
      if @entry.save!
        redirect_to entries_path(form)
      else
        save_entry_failure
      end
    end

    def save_entry_failure
      render text: 'Fail'
    end

    protected

    def new_block_path(block, options={})
      cms.new_form_entry_path(options)
    end

    def find_form_and_populate_entry
      @form = Cms::Form.find(params[:form_id])
      @entry = Cms::FormEntry.new(form: @form)
      @entry.attributes = entry_params(@entry)
    end

    def entry_params(entry)
      params.require(:form_entry).permit(entry.permitted_params)
    end

    # Allows Entries to be displayed using same view as Content Blocks.
    class FauxContentType < Cms::ContentType
      def initialize(form)
        @form = form
        self.name = 'Cms::FormEntry'
      end

      def display_name
        'Entry'
      end

      def columns_for_index
        cols = @form.fields.collect do |field|
          {:label => field.label, :method => field.name}
        end
        cols
      end
    end

    def content_type
      @content_type
    end
  end
end