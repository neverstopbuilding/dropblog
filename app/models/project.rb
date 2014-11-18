class Project < ActiveRecord::Base
  has_many :pictures, as: :imageable
  has_many :articles

  def to_param
    slug
  end
end
