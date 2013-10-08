require "minitest_helper"

describe Cms::FormResponse do
  let(:response) { Cms::FormResponse.new }
  let(:contact_form) do
    form = Cms::Form.new
    form.expects(:field_names).returns([:name, :email]).at_least_once
    form
  end

  let(:contact_form_entry) { Cms::FormResponse.new(form: contact_form) }

  describe '.new' do
    it "should create a response with no accessors" do
      response.wont_be_nil
    end
  end

  describe '#data_columns' do
    it 'should return nil for unset attributes' do
      response.data_columns['name'].must_be_nil
    end

    it 'should allow arbitrary access' do
      response.data_columns['name'] = 'Stan'
      response.save!
      response.reload.data_columns['name'].must_equal 'Stan'
    end

    it "should not share accessors across forms" do
      [:name, :email].each do |field|
        contact_form_entry.respond_to?(field).must_equal true
      end
      registration_form = Cms::Form.new
      registration_form.expects(:field_names).returns([:first_name, :last_name]).at_least_once
      registration_entry = Cms::FormResponse.new(form: registration_form)

      [:first_name, :last_name].each do |field|
        registration_entry.respond_to?(field).must_equal true
      end
      [:name, :email].each do |field|
        registration_entry.respond_to?(field).must_equal false
      end
    end

  end

  describe '#form' do

    it "should be a belongs_to association" do
      form = Cms::Form.create!(name: "Contact")
      contact_form_entry = Cms::FormResponse.new(form: form)
      contact_form_entry.save!

      contact_form_entry = Cms::FormResponse.find(contact_form_entry.id)
      contact_form_entry.form.must_equal form
    end

    it "should return a FormResponse that has accessors for the backing form" do

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
