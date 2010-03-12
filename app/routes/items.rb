class Main
  get "/" do
    if User === @account 
      @items = @account.items.latest.paginate(page: params[:page])

      haml :'items/index'
    else
      haml :'home'
    end
  end
  
  get "/items/?" do
    @items = @account.items.latest.paginate(page: params[:page])

    haml :'items/index'
  end

  get "/most-viewed" do
    @items = @account.items.latest.paginate(page: params[:page])

    haml :'items/index'
  end

  get "/liked" do
    @items = @account.likes_items.latest.paginate(page: params[:page])

    haml :'items/index'
  end

  get "/items/new" do
    login_required

    @item = Item.new(:name => params[:name])

    haml :'items/new'
  end
 
  get "/items/:id" do |id|
    @item = @account.items.find(id)
    @item.viewed!
      
    haml :'items/show'
  end

  post "/items" do
    login_required
    
    @item = current_user.items.build(params[:item])
    
    if @item.save
      { location: user_url(@item.user) }.to_json
    else
      @item.errors.to_json
    end
  end
  
  delete "/items/:id" do |id|
    login_required

    @item = current_user.items.find(id)
    @item.destroy
   
    { :location => user_url(@item.user) }.to_json
  end

  get '/friends-items' do
    @items = @account.friends_items.latest.paginate(:page => params[:page])

    haml :'items/index'
  end
end
