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

  def facebook_link(document)
    url = polymorphic_url([:short, document])
    link_to 'Facebook', "//www.facebook.com/sharer.php?u=#{url}&t=#{document.title}", class: 'social-button'
  end

  def twitter_link(document)
    url = polymorphic_url([:short, document])
    link_to 'Twitter', "//twitter.com/intent/tweet?url=#{url}&text=#{document.title}&via=jasonrobertfox", class: 'xml plain social-button'
  end

  def google_plus_link(document)
    url = polymorphic_url([:short, document])
    link_to 'Google Plus', "//plus.google.com/share?url=#{url}", class: 'social-button'
  end

  private

  def to_hex_number(letter)
    (((letter.downcase.ord - 97)/26.0) * 255).to_i
  end
end
