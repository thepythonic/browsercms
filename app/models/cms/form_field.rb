module Cms
  class FormField < ActiveRecord::Base
    extend DefaultAccessible

    attr_accessor :edit_path

    # Used for input fields. I.e. <%= f.input field.name %>
    #
    # @return [Symbol] I.e. :name or :email_address
    def name
      label.underscore.to_sym
    end

    def as_json(options={})
      super(:methods => [:edit_path])
    end
  end
end