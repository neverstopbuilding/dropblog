class InterestsController < ApplicationController
  layout 'page'

  def index
    @interests = Document.interests
  end

  def show
    @interest = params[:interest]
    @articles = Article.of_interest(@interest)
    @projects = Project.of_interest(@interest)
    if @articles.empty? && @projects.empty?
      redirect_to action: 'index'
    end
  end
end
