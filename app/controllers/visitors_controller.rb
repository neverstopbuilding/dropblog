class VisitorsController < ApplicationController
  def index
    @articles = Article.recently_updated(5)
    @projects = Project.recently_updated(5)
  end

  def prototyping
    render layout: 'page'
  end
end
