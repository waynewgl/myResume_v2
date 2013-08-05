MyResume::Application.routes.draw do
  mount RedactorRails::Engine => '/redactor_rails'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'site#index'
  match 'site/index' => 'site#index'
  match 'site/allProjects' => 'site#allProjects'
  match 'site/article_detail' => 'site#article_detail'
  match 'site/vote_article' => 'site#vote_article'
  match 'site/article_comment' => 'site#article_comment'


  get 'tags/:tag', to: 'site#allProjects', as: :tag


  match 'attachments/:id' => 'attachments#get'
  match 'attachments/:id/:thumb' => 'attachments#get'
  match 'attachments/get_filename/:id/:thumb' => 'attachments#get_filename'
  match 'attachments/get' => 'attachments#get'

  match 'admin/logout' => 'admin#logout'
  match 'admin/myProject' => 'admin#myProject'
  match 'admin/register_form' => 'admin#register_form'
  match 'admin/create_account' => 'admin#create_account'
  match 'admin/sign_in' => 'admin#sign_in'
  match 'admin/create_article' => 'admin#create_article'
  match 'admin/add_attachment' => 'admin#add_attachment'
  match 'admin/load_atts_for_article' => 'admin#load_atts_for_article'
  match 'admin/load_atts_for_profile' => 'admin#load_atts_for_profile'
  match 'admin/detach_attachment' => 'admin#detach_attachment'
  match 'admin/detach_attachment/:article_id/:att_id' => 'admin#detach_attachment'
  match 'admin/edit_profile' => 'admin#edit_profile'
  match 'admin/edit_profile_others' => 'admin#edit_profile_others'
  match 'admin/myProfile' => 'admin#myProfile'
  match 'admin/returnArticleContent' => 'admin#returnArticleContent'
  match 'admin/update_article_content' => 'admin#update_article_content'
  match 'admin/myArticle_detail' => 'admin#myArticle_detail'
  match 'admin/delete_article' => 'admin#delete_article'



  match 'resume/index' => 'resume#index'
  match 'resume' => 'resume#index'


  match 'user/:id' => 'user#get'
  match 'user/:id/:thumb' => 'user#get'
  match 'user/get_filename/:id/:thumb' => 'user#get_filename'
  match 'user/get' => 'user#get'


  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
