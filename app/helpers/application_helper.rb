module ApplicationHelper
  def title_picture_path(document)
    document.title_picture.public_path if document.title_picture
  end
end
