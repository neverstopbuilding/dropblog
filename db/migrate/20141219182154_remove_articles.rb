class RemoveArticles < ActiveRecord::Migration
  def change
    drop_table :articles
  end
end
