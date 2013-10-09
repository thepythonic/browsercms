require "minitest_helper"

describe Cms::FormEntry do
  let(:entry) { Cms::FormEntry.new }
  let(:contact_form) do
    form = Cms::Form.new
    form.expects(:field_names).returns([:name, :email]).at_least_once
    form
  end

  let(:contact_form_entry) { Cms::FormEntry.new(form: contact_form) }

  describe '.new' do
    it "should create a entry with no accessors" do
      entry.wont_be_nil
    end
  end

  describe '#data_columns' do
    it 'should return nil for unset attributes' do
      entry.data_columns['name'].must_be_nil
    end

    it 'should allow arbitrary access' do
      entry.data_columns['name'] = 'Stan'
      entry.save!
      entry.reload.data_columns['name'].must_equal 'Stan'
    end

    it "should not share accessors across forms" do
      [:name, :email].each do |field|
        contact_form_entry.respond_to?(field).must_equal true
      end
      registration_form = Cms::Form.new
      registration_form.expects(:field_names).returns([:first_name, :last_name]).at_least_once
      registration_entry = Cms::FormEntry.new(form: registration_form)

      [:first_name, :last_name].each do |field|
        registration_entry.respond_to?(field).must_equal true
      end
      [:name, :email].each do |field|
        registration_entry.respond_to?(field).must_equal false
      end
    end

    it "should coerce fields to their proper type" do
      entry.data_columns[:age] = 1
      entry.save!

      entry.reload.data_columns[:age].must_be_instance_of Fixnum
    end
  end

  describe '#form' do

    it "should be a belongs_to association" do
      form = Cms::Form.create!(name: "Contact")
      contact_form_entry = Cms::FormEntry.new(form: form)
      contact_form_entry.save!

      contact_form_entry = Cms::FormEntry.find(contact_form_entry.id)
      contact_form_entry.form.must_equal form
    end

    it "should return a Formentry that has accessors for the backing form" do

      contact_form_entry.name = "Hello"
      contact_form_entry.name.must_equal 'Hello'
      contact_form_entry.data_columns[:name].must_equal 'Hello'
      contact_form_entry.respond_to? :name
      contact_form_entry.respond_to? :email
    end

  end

  describe '#permitted_params' do
    it "should return all the fields for the specific form" do
      contact_form_entry.permitted_params.must_equal [:name, :email]
    end
  end
end
