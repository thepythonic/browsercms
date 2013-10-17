require "minitest_helper"

describe Cms::Form do

  let(:form) { Cms::Form.new(name: 'Contact Us') }
  describe '.create!' do
    it "should create a new instance" do
      form.save!
      form.name.must_equal "Contact Us"
      form.persisted?.must_equal true
    end

    it "should create a slug when created " do
      form.slug = "/contact-us"
      form.save!
      form.reload.section_node.wont_be_nil
      form.section_node.slug.must_equal "/contact-us"
    end

    it "should assign parent with created" do
      form.save!
      form.parent.wont_be_nil
      form.section_node.slug.must_equal
    end

  end

  describe '#update' do
    let(:saved_form){Cms::Form.create! }
    it "should update slug" do
      saved_form.update({name: 'New', slug: '/about-us'}).must_equal true
      saved_form.reload.section_node.slug.must_equal '/about-us'
    end
  end

  describe '.show_text?' do
    it "should return true with the :show_text confirmation behavior" do
      form.confirmation_behavior = :show_text
      form.save!
      form.reload.show_text?.must_equal true
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

    it "should set error on :base when there are duplicate fields" do
      form.fields << Cms::FormField.create(label: 'Name')
      form.fields << Cms::FormField.new(label: 'Name')
      form.valid?.must_equal false
      form.errors[:base].size.must_equal 1
      form.errors[:base].must_include "Labels can only be used once per form."
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
