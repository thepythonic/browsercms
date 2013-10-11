require "minitest_helper"

describe Cms::FormField do
  describe '.permitted_params' do
    it 'should return an array of fields' do
      Cms::FormField.permitted_params.must_equal [:form_id, :label, :field_type, :required, :unique, :instructions, :default_value]
    end
  end

  describe '#name' do
    it "should return a symbol that can be used as the name for inputs" do
      field = Cms::FormField.create!(label: 'Name')
      field.name.must_equal :name
    end

    it "should underscore names" do
      field = Cms::FormField.create!(label: 'Full Name')
      field.name.must_equal :full_name
    end

    it "should not change after being saved even when the label is changed" do
      field = Cms::FormField.create!(label: 'Name')
      field.update(label: 'Full Name')
      field.name.must_equal :name
    end
  end

  describe "#options" do
    it "can disable the input" do
      field = Cms::FormField.new(label: 'A Title', field_type: 'text_field')
      field.options(disabled: true).must_equal({label: 'A Title', disabled: true, readonly: 'readonly'})
    end
    it "should provide as: for default cases" do
      field = Cms::FormField.new(label: 'A Title', field_type: 'text_field')
      field.options.must_equal({label: 'A Title'})
    end

    it "should provide as: for special cases" do
      field = Cms::FormField.new(label: 'A Title', field_type: 'text_area')
      field.options.must_equal({label: 'A Title', as: :text})
    end
  end

  describe "#as" do
    it "should handle text_fields" do
      field = Cms::FormField.new(field_type: 'text_field')
      field.as.must_equal :string
    end

    it "should handle text_areas" do
      field = Cms::FormField.new(field_type: 'text_area')
      field.as.must_equal :text
    end
  end

  describe "#as_json" do
    let(:field) { Cms::FormField.new(label: 'Name') }
    it "should include #edit_path when being serialized" do
      field.edit_path = "/cms/form_fields/1/edit"
      json = JSON.parse(field.to_json)
      json["edit_path"].must_equal "/cms/form_fields/1/edit"
    end
  end
end
