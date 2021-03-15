Rottenpotatoes::Application.routes.draw do
  resources :movies
  # map '/' to be a redirect to '/movies'
  root :to => redirect('/movies')
  
  match 'find_movies_with_same_director/:id', to: 'movies#similar', as: 'search_director', via: :get
end
