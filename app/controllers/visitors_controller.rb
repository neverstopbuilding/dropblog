class VisitorsController < ApplicationController
  def index
    @articles = Article.recent(5)
    @projects = Project.recent(5)
  end

  def consulting
    render layout: 'page'
  end

  def services
    render layout: 'page'
  end
end
