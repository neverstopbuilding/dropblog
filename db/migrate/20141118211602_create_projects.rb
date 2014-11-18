class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title
      t.string :slug
      t.text :content
      t.boolean :public

      t.timestamps
    end
  end
end
