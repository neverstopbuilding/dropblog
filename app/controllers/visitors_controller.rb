class VisitorsController < ApplicationController
  def index
    @articles = Article.recent
    @projects = Project.recent
  end
end
