class InterestsController < ApplicationController
  layout 'page'

  def index
    interests =
    @interests = []

    Document.interests.each do |interest|
      @interests << {interest: interest, picture_path: get_path_for_interest(interest)}
    end


  end

  def show
    @interest = params[:interest]
    @articles = Article.of_interest(@interest)
    @projects = Project.of_interest(@interest)
    if @articles.empty? && @projects.empty?
      redirect_to action: 'index'
    end
  end

  def get_path_for_interest(interest)
    picture = Picture.joins('LEFT JOIN documents pictures_documents ON pictures_documents.id = pictures.document_id').where('pictures_documents.category = :category', category: interest).first
    picture.public_path if picture
  end

end
