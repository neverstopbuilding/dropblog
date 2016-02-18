class ProjectsController < ApplicationController
  layout 'page'

  def index
    @projects = Project.order(updated_at: :desc)
  end

  def show
    @project = Project.find_by_slug(params[:id])
  end
end
