module ApplicationHelper
  def title_picture_path(document)
    document.title_picture.public_path if document.title_picture
  end

  def string_color(string)
    r = to_hex_number(string[0])
    g = to_hex_number(string[1])
    b = to_hex_number(string[2])
    "rgb(#{r}, #{g}, #{b}"
  end

  private

  def to_hex_number(letter)
    (((letter.downcase.ord - 97)/26.0) * 255).to_i
  end
end
