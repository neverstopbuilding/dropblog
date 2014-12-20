class Picture < ActiveRecord::Base
  belongs_to :document

  validates :file_name, :public_path, :document, presence: true

  def self.process_picture(file_name, public_path, document)
    picture = document.pictures.find_or_create_by(file_name: file_name)
    picture.public_path = public_path
    document.save
    picture
  end

  def self.destroy_by_file_name(file_name, document)
    to_delete = document.pictures.find_by_file_name(file_name)
    to_delete.destroy if to_delete
  end
end
