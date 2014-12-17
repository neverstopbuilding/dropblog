class VisitorsController < ApplicationController
  def index
    @articles = Article.recent
  end
end
