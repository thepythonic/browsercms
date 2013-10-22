require "test_helper"

module Dummy
  class DeprecatedInputTest < ActiveSupport::TestCase

    test "#model_form_name should use full model name" do
      assert_equal "dummy_deprecated_input", DeprecatedInput.content_type.model_class_form_name
    end
  end
end
