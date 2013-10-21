module Cms::RouteExtensions


  # Adds all necessary routes to manage a new content type. Works very similar to the Rails _resources_ method, adding basic CRUD routes, as well as additional ones
  #   for CMS specific routes (like versioning)
  #
  # @param [Symbol] content_block_name - The plural name of a new Content Type. Should match the name of the model_class, like :dogs or :donation_statuses
  def content_blocks(content_block_name, options={}, & block)
    model_class = guess_model_class(content_block_name)

    resources content_block_name do
      member do
        put :publish if model_class.publishable?
        get :versions if model_class.versioned?
        get :usages if model_class.connectable?
      end
    end

    if model_class.versioned?
      send("get", "/#{content_block_name}/:id/version/:version", :to => "#{content_block_name}#version", :as => "version_cms_#{content_block_name}".to_sym)
      send("put", "/#{content_block_name}/:id/revert_to/:version", :to => "#{content_block_name}#revert_to", :as => "revert_to_cms_#{content_block_name}".to_sym)
    end

  end

  # Adds the routes required for BrowserCMS to function to a routes.rb file. Should be the last route in the file, as
  # all following routes will be ignored.
  #
  # Usage:
  #   YourAppName::Application.routes.draw do
  #      match '/some/path/in/your/app' :to=>"controller#action''
  #      mount_browsercms
  #   end
  #
  def mount_browsercms

    mount Cms::Engine => "/cms", :as => "cms"

    add_page_routes_defined_in_database

    # Handle 'stock' attachments
    get "/attachments/:id/:filename", :to => "cms/attachments#download"
    get "/", :to => "cms/content#show"

    # Only need :POST to support  portlets that are acting like controllers.
    # Ideally we could get rid of this need.
    match "*path", :to => "cms/content#show", via: [:get, :post]
  end

  # Preserving for backwards compatibility with bcms-3.3.x and earlier.
  # @deprecated
  alias :routes_for_browser_cms :mount_browsercms

  private

  def guess_model_class(content_block_name)
    content_name = content_block_name.to_s.classify
    prefix = determine_model_prefix
    begin
      namespaced_model_name = "#{Cms::Module.current_namespace}::#{content_name}"
      model_class = namespaced_model_name.constantize
    rescue NameError
      model_class = "#{prefix}#{content_name}".constantize
    end
    model_class
  end

  def determine_model_prefix
    if @scope && @scope[:module]
      "#{@scope[:module].camelize}::"
    else
      ""
    end
  end


  # Define additional routes (in the main_app) that addressable content types need.
  def add_routes_for_addressable_content_blocks
    classes = Cms::Concerns::Addressable.classes_that_require_custom_routes
    classes.each do |klass|
      base_route_name = klass.name.demodulize.underscore.gsub("/", "_")
      add_show_via_slug_route(base_route_name, klass)
      add_inline_content_route(base_route_name, klass)
    end
  end

  # I.e. /cms/forms/:id/inline
  def add_inline_content_route(base_route_name, klass)
    denamespaced_controller = klass.name.demodulize.pluralize.underscore
    module_name = klass.name.deconstantize.underscore
    inline_route_name = "#{base_route_name}_inline"
    unless route_exists?(inline_route_name)
      Rails.application.routes.prepend do
        namespace module_name do
          get "#{klass.path}/:id/inline", to: "#{denamespaced_controller}#inline", as: inline_route_name
        end
      end
    end
  end

  # I.e. /forms/:slug
  def add_show_via_slug_route(base_route_name, klass)
    slug_path = "#{klass.path}/:slug"
    namespaced_controller = klass.name.underscore.pluralize
    slug_path_name = "#{base_route_name}_slug"
    # Add route to main application (By doing this here, we ensure all ContentBlock constants have already been load)
    # Engines don't process their routes until after the main routes are created.
    unless route_exists?(slug_path_name)
      Rails.application.routes.prepend do
        get slug_path, to: "#{namespaced_controller}#show_via_slug", as: slug_path_name
      end
    end
  end

  # Determine if a named route already exists, since Rails 4 will object if a duplicate named route is defined now.
  # Otherwise in development, when routes are reloaded the CMS would throw errors.
  def route_exists?(route_name)
    Rails.application.routes.named_routes[route_name]
  end

  def add_page_routes_defined_in_database
    if Cms::PageRoute.can_be_loaded?
      Cms::PageRoute.order("#{Cms::PageRoute.table_name}.name").each do |r|
        match r.pattern, :to => r.to, :as => r.route_name, :_page_route_id => r.page_route_id, :via => r.via, :constraints => r.constraints
      end
    end
  end
end
