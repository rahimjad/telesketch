class FirstMigration < ActiveRecord::Migration

  def change
    
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :image
      t.timestamps
    end

    create_table :stories do |t|
      t.string :category
      t.boolean :complete, default: false
      t.timestamps
    end

    create_table :inputs do |t|
      t.references :story
      t.references :user
      t.string :type
      t.string :caption
      t.string :image_path
      t.timestamps
    end



    create_table :ratings do |t|
      t.references :story
      t.references :user
      t.integer :score
      t.timestamps
    end
  end
end
