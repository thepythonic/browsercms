class CreateForms < ActiveRecord::Migration
  def change
    create_content_table :forms do |t|
      t.string :name
      t.text :description
      t.string :confirmation_behavior
      t.text :confirmation_text
      t.string :confirmation_redirect
      t.timestamps
    end
  end
end
