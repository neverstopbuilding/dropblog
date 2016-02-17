class VisitorsController < ApplicationController
  def index
    @articles = Article.recent(5)
    @projects = Project.recent(5)
  end

  def prototyping
    render layout: 'page'
  end
end
