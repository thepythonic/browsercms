module Cms
  class FormField < ActiveRecord::Base
    extend DefaultAccessible

    # Used for input fields. I.e. <%= f.input field.name %>
    #
    # @return [Symbol] I.e. :name or :email_address
    def name
      label.underscore.to_sym
    end
  end
end