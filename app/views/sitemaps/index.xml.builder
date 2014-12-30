def add_map(xml, location, frequency)
    xml.url {
        xml.loc(location)
        xml.changefreq(frequency)
        xml.priority(1.0)
    }
end

def add_doc(xml, document, frequency)
      xml.url {
        xml.loc(polymorphic_url([:short, document]))
        xml.changefreq(frequency)
        xml.lastmod document.updated_at.strftime("%F")
        xml.priority(1.0)
    }
end

base_url = "http://#{request.host_with_port}"
xml.instruct! :xml, :version=>'1.0'
xml.tag! 'urlset', 'xmlns' => 'http://www.sitemaps.org/schemas/sitemap/0.9' do
  @weekly.each do |location|
      add_map(xml, location, 'weekly')
  end
  @monthly.each do |location|
    add_map(xml, location, 'monthly')
  end
  @yearly.each do |location|
    add_map(xml, location, 'yearly')
  end
  @interests.each do |interest|
    add_map(xml, interest_url(interest), 'monthly')
  end

  @articles.each do |article|
    add_doc(xml, article, 'monthly')
  end

  @projects.each do |article|
    add_doc(xml, article, 'weekly')
  end
end
