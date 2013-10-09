require "minitest_helper"

describe Cms::FormField do
  describe '.permitted_params' do
    it 'should return an array of fields' do
      Cms::FormField.permitted_params.must_equal [:form_id, :label, :field_type, :required, :unique, :instructions, :default_value]
    end
  end

  describe '#name' do
    it "should return a symbol that can be used as the name for inputs" do
      field = Cms::FormField.new(label: 'Name')
      field.name.must_equal :name
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
