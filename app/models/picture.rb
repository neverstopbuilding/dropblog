class Picture < ActiveRecord::Base
  belongs_to :document

  validates :file_name, :public_path, :document, presence: true
end
