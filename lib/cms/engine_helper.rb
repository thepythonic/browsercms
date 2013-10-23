module Cms

  class EngineAwarePathBuilder

    def initialize(model_class_or_content_type_or_model)
      normalize_subject_class(model_class_or_content_type_or_model)
    end

    # The object that will be added to the constructed path.
    def path_subject
      @path_subject
    end

    def subject_class
      if @path_subject.instance_of?(Class)
        @path_subject
      else
        @path_subject.class
      end
    end

    def build_preview(view)
      path = []
      path << engine_name
      path << path_subject
      path
    end

    def build(view)
      path = []
      path << engine(view)
      path << path_subject
      path

    end

    def main_app_model?
      engine_name == "main_app"
    end

    # Determine which 'Engine' this model is from based on the class
    def engine_name
      model_class = subject_class.model_name
      name = EngineHelper.module_name(model_class)
      return "main_app" unless name

      begin
        engine = "#{name}::Engine".constantize
      rescue NameError
        # This means there is no Engine for this model, so its from the main Rails App.
        return "main_app"
      end
      engine.engine_name
    end

    private

    # Allows ContentType, Class, or model to be passed.
    def normalize_subject_class(model_class_or_content_type_or_model)
      if model_class_or_content_type_or_model.respond_to? :model_class # i.e. ContentType
        @path_subject = model_class_or_content_type_or_model.model_class
      else # Class or Model
        @path_subject = model_class_or_content_type_or_model
      end
    end

    # Loads the actual engine (which contains the RouteSet.)
    # See http://api.rubyonrails.org/classes/ActionDispatch/Routing/PolymorphicRoutes.html
    def engine(view)
      view.send(engine_name)
    end

  end

  module EngineHelper


    # Returns the specific engine this contenttype belongs to.
    def engine
      if main_app_model?
        Rails.application
      else
        engine_class(target_class)
      end
    end

    def main_app_model?
      engine_name == "main_app"
    end

    def engine_exists?
      !main_app_model?
    end


    def engine_name
      path_builder.engine_name
    end

    def path_builder
      @path_builder ||= EngineAwarePathBuilder.new(target_class)
    end

    # Will raise NameError if klass::Engine doesn't exist.
    def engine_class(klass)
      name = EngineHelper.module_name(klass)
      "#{name}::Engine".constantize
    end

    # Subclasses can override this as necessary
    def target_class
      return self.class unless self.instance_of?(Class)
      self
    end

    # Subclasses can override this as necessary
    def path_subject
      self
    end

    # Add this module if its not already.
    def self.decorate(instance)
      instance.extend EngineHelper unless instance.respond_to?(:engine_name)
    end

    # Finds the top level module for a given class.
    # Cms::Thing -> Cms
    # Thing -> nil
    # Whatever::Thing -> Whatever
    #
    # @param [Class] klass
    def self.module_name(klass)
      names = klass.name.split("::")
      return names.first if names.size > 1
      nil
    end
  end
end