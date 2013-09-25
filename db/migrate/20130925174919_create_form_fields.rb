class CreateFormFields < ActiveRecord::Migration
  def change
    create_table :cms_form_fields do |t|
      t.integer :form_id
      t.string :label
      t.string :field_type
      t.boolean :required
      t.boolean :unique
      t.text :instructions
      t.text :default_value
    end
  end
end
