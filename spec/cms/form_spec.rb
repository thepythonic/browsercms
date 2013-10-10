require "minitest_helper"

describe Cms::Form do

  let(:form) { Cms::Form.new(name: 'Contact Us') }
  describe '.create!' do
    it "should create a new instance" do
      form.save!
      form.name.must_equal "Contact Us"
      form.persisted?.must_equal true
    end
  end

  describe '#fields' do
    it "should save a list of fields" do
      field = Cms::FormField.new(label: "Event Name", field_type: :string)
      form.fields << field
      form.save!

      form.reload.fields.size.must_equal 1
      field.persisted?.must_equal true
    end
  end

  describe '#field_names' do
    it "should return a list of the field names as symbols" do
      form = Cms::Form.new
      form.fields << Cms::FormField.new(label: 'Name')
      form.fields << Cms::FormField.new(label: 'Email')
      form.save!
      form.field_names.must_equal [:name, :email]
    end
  end
end
