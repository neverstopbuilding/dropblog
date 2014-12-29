# Change this to your host. See the readme at https://github.com/lassebunk/dynamic_sitemaps
# for examples of multiple hosts and folders.
host "neverstopbuilding.com"

sitemap :site do
  url root_url, last_mod: Time.now, change_freq: "daily", priority: 1.0
  url articles_url, last_mod: Time.now, change_freq: "weekly", priority: 1.0
  url projects_url, last_mod: Time.now, change_freq: "weekly", priority: 1.0
  url interests_url, last_mod: Time.now, change_freq: "monthly", priority: 1.0
  url services_url, last_mod: Time.parse('2014-12-29'), change_freq: "yearly", priority: 1.0
  url consulting_url, last_mod: Time.parse('2014-12-29'), change_freq: "yearly", priority: 1.0

  Article.all.each do |article|
    url polymorphic_url([:short, article]), last_mod: article.updated_at, priority: 1.0
  end

  Project.all.each do |project|
    url polymorphic_url([:short, project]), last_mod: project.updated_at, priority: 1.0
  end
end


# Ping search engines after sitemap generation:
#
# ping_with "http://#{host}/sitemap.xml"
