class ProjectsController < ApplicationController
  layout 'page'

  def index
    @projects = Project.all
  end

  def show
    @project = Project.find_by_slug(params[:id])
  end
end
