class SeparateTextPicture < ActiveRecord::Migration
  def change
    drop_table :inputs

    create_table :pictures do |t|
      t.references :story
      t.references :user
      t.string :content
      t.timestamps
    end    

    create_table :texts do |t|
      t.references :story
      t.references :user
      t.string :content
      t.timestamps
    end
  end
end
