class ArticlesController < ApplicationController
  layout 'page'

  def index
    @articles = Article.order(created_at: :desc)
  end

  def show
    @article = Article.find_by_slug(params[:id])
  end
end
