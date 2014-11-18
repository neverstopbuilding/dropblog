class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.string :slug
      t.text :content
      t.boolean :public
      t.integer :project_id
      t.timestamps
    end
  end
end
