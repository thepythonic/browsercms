require "minitest_helper"

describe Cms::FormResponse do
  describe '#data_columns' do

    let(:response) { Cms::FormResponse.new }
    it 'should return nil for unset attributes' do
      response.data_columns['name'].must_be_nil
    end

    it 'should allow arbitrary access' do
      response = Cms::FormResponse.new
      response.data_columns['name'] = 'Stan'
      response.save!

      response.reload.data_columns['name'].must_equal 'Stan'
    end

  end

  describe '.form_for' do
    it "should return a FormResponse that has accessors for the backing form" do
      form = Cms::Form.new
      form.expects(:field_names).returns([:name, :email]).at_least_once

      form_response = Cms::FormResponse.for_form(form)
      form_response.respond_to? :name
      form_response.respond_to? :email
    end
  end

  describe '#permitted_params' do
    it "should return all the fields for the specific form" do
      form = Cms::Form.new
      form.expects(:field_names).returns([:name, :email]).at_least_once

      form_response = Cms::FormResponse.for_form(form)
      form_response.permitted_params.must_equal [:name, :email]
    end
  end
end
