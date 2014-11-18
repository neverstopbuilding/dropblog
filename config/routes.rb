class PostUrlConstrainer
  def matches?(request)
    id = request.path.gsub("/", "")
    Article.find_by_slug(id)
  end
end

class AuthorUrlConstrainer
  def matches?(request)
    id = request.path.gsub("/", "")
    Project.find_by_slug(id)
  end
end

Rails.application.routes.draw do


  get 'projects', to: 'projects#index'

  namespace :api do
    get 'dropbox', to: 'dropbox#challenge'
    post 'dropbox', to: 'dropbox#webhook', format: :json
  end

  root to: 'visitors#index'




  constraints(AuthorUrlConstrainer.new) do
    get '/:id', to: "projects#show", as: 'short_project'
  end



  constraints(PostUrlConstrainer.new) do
    get '/:id', to: "articles#show", as: 'short_article'
  end

end
