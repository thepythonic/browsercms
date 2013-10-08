class CreateFormResponses < ActiveRecord::Migration
  def change
    create_table :cms_form_responses do |t|
      t.text :data_columns
    end
  end
end
