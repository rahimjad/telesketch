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
      t.timestamps
    end

    create_table :images do |t|
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

    create_table :ratings do |t|
      t.references :story
      t.references :user
      t.integer :score
      t.timestamps
    end
  end
end
