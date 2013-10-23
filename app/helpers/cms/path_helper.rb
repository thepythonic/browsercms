module Cms

  # @todo All methods really need to be renamed to match conventions for Engines.
  # In CMS::Engine, shouldn't have cms_ in method name.
  # From app, should be cms.xyz_path
  module PathHelper

    # Returns the relative path to the given attachment.
    # Content editors will see exact specific version path, while other users will see the 'public' url for the path.
    def attachment_path_for(attachment)
      return "" unless attachment
      if current_user.able_to?(:edit_content)
        attachment.attachment_version_path
      else
        attachment.url
      end
    end

    # Returns a path to sort a table of Content Blocks by a given parameter. Retains other relevant parameters (like search criteria).
    #
    # @param [Cms::ContentType] content_type
    # @param [String] column_to_sort The name of the column to sort on.
    def sortable_column_path(content_type, column_to_sort)
      filtered_params = params.clone
      filtered_params.delete(:action)
      filtered_params.delete(:controller)
      filtered_params.merge!(:order => determine_order(filtered_params[:order], column_to_sort))
      polymorphic_path(engine_aware_path(content_type.model_class), filtered_params)
    end


    # @todo Really needs to be renamed to match conventions for Engines.
    # In CMS::Engine, should be edit_connectable_path
    # From app, should be cms.edit_connectable_path
    def edit_cms_connectable_path(connectable, options={})
      if Portlet === connectable
        edit_portlet_path(connectable, options)
      else
        edit_polymorphic_path(build_path_for(connectable), options)
      end
    end

    def link_to_usages(block)
      count = block.connected_pages.count
      if count > 0
        # Would love a cleaner solution to this problem, see http://stackoverflow.com/questions/702728
        path = if Portlet === block
                 usages_portlet_path(block)
               else
                 p = []
                 p << engine_for(block)
                 p << :usages
                 p.concat path_elements_for(block)
                 p
               end
        link_to count, path, :id => block.id, :block_type => block.content_block_type
      else
        count
      end
    end


    # Returns the route proxy (aka engine) for a given resource, which can then have named paths called on it.
    #  I.e. engine(@block).polymorphic_path([@block, :preview])
    # 
    # @param [ActiveRecord::Base] resource
    # @return [ActionDispatch::Routing::RoutesProxy]
    def engine(resource)
      EngineHelper.decorate(resource)
      send(resource.engine_name)
    end

    # @deprecated
    alias :engine_for :engine

    def path_elements_for(resource)
      EngineHelper.decorate(resource)
      resource.path_elements
    end

    # Return the path for a given resource. Determines the relevant engine, and the result can be passed to polymporhic_path
    #
    # @param [Object] model_or_class_or_content_type A content block, class or content type.
    # @param [String] action (Optional) i.e. :edit
    # @return [Array] An array of argument suitable to be passed to url_for or link_to helpers. This will be something like:
    #     [main_app, :dummy_products, @block, :edit]
    #  or [cms, :html_blocks, @block]
    #
    # This will work whether the block is:
    #   1. A block in a project (namespaced to the project) (i.e. Dummy::Product)
    #   2. A core CMS block (i.e. Cms::Portlet)
    #   3. A block in a module (i.e. BcmsNews::NewsArticle)
    # e.g.
    #   engine_aware_path(Dummy::Product.find(1)) => /dummy/products/1
    #   engine_aware_path(Cms::HtmlBlock.find(1)) => /cms/html_blocks/1
    #   engine_aware_path(BcmsNews::NewsArticle.find(1)) => /bcms_news/news_articles/1
    #
    def engine_aware_path(model_or_class_or_content_type, action = false)
      elements = build_path_for(model_or_class_or_content_type)
      elements << action if action
      elements
    end

    # Wrappers edit_polymorphic_path to be engine aware.
    def edit_engine_aware_path(model_or_class_or_content_type)
      edit_polymorphic_path(build_path_for(model_or_class_or_content_type))
    end

    # Wrappers new_polymorphic_path to be engine aware.
    def new_engine_aware_path(subject)
      new_polymorphic_path(build_path_for(subject))
    end

    private

    def build_path_for(model_or_class_or_content_type)
      Cms::EngineAwarePathBuilder.new(model_or_class_or_content_type).build(self)
    end


    # Returns the name of the collection that this resource belongs to
    # the resource can be a ContentType, ActiveRecord::Base instance
    # or just a string or symbol
    def resource_collection_name(resource)
      if resource.respond_to?(:resource_collection_name)
        return resource.resource_collection_name
      end
      case resource
        when ContentType then
          resource.route_name
        when ActiveRecord::Base then
          resource.class.model_name.demodulize
        else
          resource.to_s
      end
    end

  end
end
