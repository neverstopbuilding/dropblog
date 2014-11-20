class ChangePictureColumns < ActiveRecord::Migration
  def change
    rename_column :pictures, :imageable_id, :pictureable_id
    rename_column :pictures, :imageable_type, :pictureable_type
  end
end
