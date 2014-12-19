class CreatePictures < ActiveRecord::Migration
  def change

    rename_column :pictures, :path, :public_path
    remove_column :pictures, :pictureable_type
    remove_column :pictures, :pictureable_id

    change_table :pictures do |t|
      t.references :document, index: true
    end

    add_index :pictures, :file_name
    add_foreign_key :pictures, :documents
  end
end
