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

  constraints subdomain: 'www' do
    get ':any', to: redirect(subdomain: nil, path: '/%{any}'), any: /.*/
  end

  # Redirect atom to home page indefinitly for legacy requests
  get 'atom.xml', to: redirect('/'), format: 'xml'

  get 'projects', to: 'projects#index', as: 'projects'
  get 'articles', to: 'articles#index', as: 'articles'

  get '/project/:slug', to: redirect('/%{slug}')

  get 'interests', to: 'interests#index', as: 'interests'
  get 'interests/:interest', to: 'interests#show', as: 'interest'

  get 'services', to: 'visitors#services'
  get 'consulting', to: 'visitors#consulting'

  namespace :api do
    get 'dropbox', to: 'dropbox#challenge'
    post 'dropbox', to: 'dropbox#webhook', format: :json
  end

  root to: 'visitors#index'

  get 'sitemap.xml' => 'sitemaps#index', :format => 'xml', :as => :sitemap

  constraints(AuthorUrlConstrainer.new) do
    get '/:id', to: "projects#show", as: 'short_project'
  end

  constraints(PostUrlConstrainer.new) do
    get '/:id', to: "articles#show", as: 'short_article'
  end

end
