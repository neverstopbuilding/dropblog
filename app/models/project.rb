class Project < ActiveRecord::Base
  has_many :pictures, as: :pictureable
  has_many :articles

  def to_param
    slug
  end


  # the project and article (which are really rather similar) should contain raw markdown,
  # this will have relative slug links to the images
  # durring parsing it will use the slugs to pull in the actual image path

  # articles and projects are basically the same thing
  # so we could say an article is documentable as is a project
  # projects only really have sub articles related to them
  # any content is imagable, categorizable, taggable, etc it has a title, slug, content
  # it can be uniformly rendered

  # could use single table inheretance with
end
