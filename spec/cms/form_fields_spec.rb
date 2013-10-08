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
end
