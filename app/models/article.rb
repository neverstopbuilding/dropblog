class Article < ActiveRecord::Base
  has_many :pictures, as: :imageable
  belongs_to :project

  def to_param
    slug
  end
end
