class CreateForms < ActiveRecord::Migration
  def change
    create_content_table :forms do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
