class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string :slug
      t.string :title
      t.text :content
      t.string :type
      t.string :category
      t.references :document, index: true

      t.timestamps null: false
    end
    add_index :documents, :slug, unique: true
    add_foreign_key :documents, :documents
  end
end
