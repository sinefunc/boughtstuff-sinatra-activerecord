class Main
  get '/:username/:filter/?' do |username, filter|
    if %w(items most-viewed liked friends-items).include?(filter)
      unless username == AnonymousUser::USERNAME
        @account = User.find_by_username( username )
      else
        @account = AnonymousUser.new
      end
    end

    pass
  end

  get '/' do
    redirect('/everyone/items')
  end
  
  get '/:username/?' do |username|
    if @account = User.find_by_username( username )
      @items = @account.items.latest.paginate(page: params[:page])

      haml :'items/index'
    else
      pass
    end
  end

  get '/:username/items/?' do
    @items = @account.items.latest.paginate(page: params[:page])

    haml :'items/index'
  end
  
  get '/:username/tagged/:tag' do
    @items = @account.items.tagged(params[:tag]).paginate(:page => params[:page])

    haml :'items/index'
  end

  get "/:username/most-viewed" do
    @items = @account.items.most_viewed.paginate(page: params[:page])

    haml :'items/index'
  end

  get "/:username/liked" do
    @items = @account.likes_items.latest.paginate(page: params[:page])

    haml :'items/index'
  end

  get '/:username/friends-items' do
    @items = @account.friends_items.latest.paginate(:page => params[:page])

    haml :'items/index'
  end

  get "/items/new" do
    login_required

    @item = Item.new(:name => params[:name])

    haml :'items/new'
  end
 
  get "/:username/:id" do |username, id|
    unless @account = User.find_by_username(username)
      pass
    end

    @item    = @account.items.find(id)
    @item.viewed!
      
    haml :'items/show'
  end

  post "/items" do
    login_required
    
    content_type 'text/plain'
    
    @item = current_user.items.build(params[:item])
    
    if @item.save
      { location: user_url(@item.user) }.to_json
    else
      @item.errors.to_json
    end
  end
  
  delete "/:username/:id" do |username, id|
    login_required
    
    content_type 'text/plain'
    
    @item = current_user.items.find(id)
    @item.destroy
    
    { :location => user_url(@item.user) }.to_json
  end
end
