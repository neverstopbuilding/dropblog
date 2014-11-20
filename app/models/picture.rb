class Picture < ActiveRecord::Base
  belongs_to :pictureable, polymorphic: true

  validates :file_name, presence: true
end
