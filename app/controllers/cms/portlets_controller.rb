module Cms
class PortletsController < Cms::ContentBlockController
  
  protected
    def load_blocks
      @blocks = Portlet.where(deleted: false).search(params[:search]).paginate(
        :page => params[:page],
      ).order(params[:order] || "name")
    end
  
    def build_block
      if params[:type].blank?
        @block = model_class.new
      else
        @block = params[:type].classify.constantize.new(params[:portlet])
      end

    end
    
    def update_block
      load_block
      @block.update(params[:portlet])
    end    
    
    def block_form
      "portlets/portlets/form"
    end
    
    def new_block_path(block)
      new_portlet_path
    end

    def blocks_path
      portlets_path
    end
end
end