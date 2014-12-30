class SitemapsController < ApplicationController
  def index

    @weekly = [root_url, articles_url, projects_url]
    @monthly = [interests_url]
    @yearly = [consulting_url, services_url]

    @articles = Article.all
    @projects = Project.all
    @interests = Document.interests

    respond_to do |format|
      format.xml
    end
  end
end
