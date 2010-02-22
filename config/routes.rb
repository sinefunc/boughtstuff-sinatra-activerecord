ActionController::Routing::Routes.draw do |map|
  map.resource  :dashboard
  map.resources :items

  map.root :controller => 'pages', :action => 'home'
end
