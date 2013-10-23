require "test_helper"

module Cms
  class CoreContentBlock
    extend Cms::Concerns::HasContentType
    has_content_type

    def self.connectable?
      false
    end

    include EngineHelper

    extend ::ActiveModel::Naming
  end
end

module Dummy
  class MainAppThing
    include Cms::EngineHelper
    extend ::ActiveModel::Naming
  end
end

class NewThing

end

class PortletSubclass < Cms::Portlet

end

module BcmsWidgets
  class Engine < Rails::Engine
  end
  class ContentBlock
    include Cms::EngineHelper
    extend ::ActiveModel::Naming
  end
end

class BcmsParts
  class ContentThing
    include Cms::EngineHelper
  end
end

module ExpectedMockViews

  def view_for_cms_engine
    mock_view.expects(:cms).returns(:cms_engine)
    mock_view
  end

  def view_for_main_app
    mock_view.expects(:main_app).returns(:main_app)
    mock_view
  end

  def view_for_bcms_widgets_engine
    mock_view.expects(:bcms_widgets_engine).returns(:bcms_widgets_engine)
    mock_view
  end

  def mock_view
    return @view if @view
    @view = stub()
  end
end

module Cms
  class EngineHelperTest < ActiveSupport::TestCase

    def main_app_model
      @engine_helper ||= Dummy::MainAppThing.new
    end

    def setup
      @cms_block = Cms::CoreContentBlock.new
    end

    test "#application_name" do
      assert_equal "Dummy", main_app_model.application_name
    end

    test "#main_app?" do
      assert_equal true, main_app_model.main_app_model?
      assert_equal false, @cms_block.main_app_model?
      assert_equal false, BcmsWidgets::ContentBlock.new.main_app_model?
    end

    test "If there is no Engine, engine_name should be the main app." do
      assert_equal "main_app", BcmsParts::ContentThing.new.engine_name
    end

    test "#module_name" do
      assert_equal "Cms", EngineHelper.module_name(Cms::CoreContentBlock)
      assert_nil EngineHelper.module_name(NewThing)
      assert_equal "BcmsWidgets", EngineHelper.module_name(BcmsWidgets::ContentBlock)
    end

    test "path_for_widget" do
      name = BcmsWidgets::ContentBlock.new.engine_name
      assert_not_nil name
      assert_equal BcmsWidgets::Engine.engine_name, name
    end

    test "Decorate" do
      n = NewThing.new
      EngineHelper.decorate(n)
      assert_equal true, n.respond_to?(:engine_name)
    end

    test "Decorate class" do
      EngineHelper.decorate(NewThing)
      assert_equal true, NewThing.respond_to?(:engine_name)
    end

    test "Don't decorate twice'" do
      class DecorateOnce
        include EngineHelper

        def engine_name
          "Original"
        end
      end
      subject = DecorateOnce.new
      EngineHelper.decorate(subject)
      assert_equal "Original", subject.engine_name

    end
    test "Engine Name" do
      assert_equal "cms", Cms::Engine.engine_name
    end

    test "calculate engine_name" do
      assert_equal "cms", Cms::CoreContentBlock.new.engine_name
    end

    test "Blocks without namespace should be in main app" do
      assert_equal "main_app", Dummy::MainAppThing.new.engine_name
    end

    test "path_elements for an instance of a class in an application" do
      assert_equal [main_app_model], main_app_model.path_elements
    end

    test "path_elements for a class in an application" do
      Dummy::MainAppThing.extend EngineHelper
      assert_equal [Dummy::MainAppThing], Dummy::MainAppThing.path_elements
    end

    test "path_elements for an instance of in Cms namespace" do
      assert_equal [@cms_block], @cms_block.path_elements
    end

    test "path_elements for a class in Cms namespace" do
      Cms::CoreContentBlock.extend EngineHelper
      assert_equal [Cms::CoreContentBlock], Cms::CoreContentBlock.path_elements
    end

    test "path_elements for a class in a module" do
      BcmsWidgets::ContentBlock.extend EngineHelper
      assert_equal [BcmsWidgets::ContentBlock], BcmsWidgets::ContentBlock.path_elements
    end

  end


  class ContentBlocksEnginePathsTest < ActiveSupport::TestCase
    include ExpectedMockViews

    def setup
      @pathbuilder = EngineAwarePathBuilder.new(Cms::CoreContentBlock)
    end

    test "subject_class" do
      assert_equal Cms::CoreContentBlock, @pathbuilder.subject_class
    end

    test "engine_name" do
      assert_equal "cms", @pathbuilder.engine_name
    end

    test "build for Core Cms class" do
      assert_equal [:cms_engine, Cms::CoreContentBlock], @pathbuilder.build(view_for_cms_engine)
    end

    test "#engine_name for classes that support PolymorphicSTI" do
      assert_equal "cms", path_builder(PortletSubclass).engine_name
    end

    private

    def path_builder(klass)
      EngineAwarePathBuilder.new(klass)
    end

  end

  class PathsWithContentTypeTest < ActiveSupport::TestCase
    include ExpectedMockViews

    def setup
      ct = Cms::CoreContentBlock.content_type
      @pathbuilder = EngineAwarePathBuilder.new(ct)
    end

    test "build for contenttype" do
      assert_equal [:cms_engine, Cms::CoreContentBlock], @pathbuilder.build(view_for_cms_engine)
    end
  end

  class EngineAwarePathsTest < ActiveSupport::TestCase
    include ExpectedMockViews
    test "build for custom block class" do
      pathbuilder = EngineAwarePathBuilder.new(Dummy::MainAppThing)
      assert_equal [:main_app, Dummy::MainAppThing], pathbuilder.build(view_for_main_app)
    end

    test "paths for block from a module" do
      pathbuilder = EngineAwarePathBuilder.new(BcmsWidgets::ContentBlock)
      assert_equal [:bcms_widgets_engine, BcmsWidgets::ContentBlock], pathbuilder.build(view_for_bcms_widgets_engine)
    end

    test "build for model" do
      block = Cms::CoreContentBlock.new
      pathbuilder = EngineAwarePathBuilder.new(block)
      assert_equal [:cms_engine, block], pathbuilder.build(view_for_cms_engine)
    end


  end

end