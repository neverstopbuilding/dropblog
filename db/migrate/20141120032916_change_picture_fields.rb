class ChangePictureFields < ActiveRecord::Migration
  def change
    rename_column :pictures, :slug, :file_name
  end
end
