class Main
  before do
    if account_subdomain and account_subdomain != 'www'
      @account = User.find_by_username( account_subdomain )
    else
      @account = Anonymous.new
    end 
  end
  
  get "/" do
    haml "%h1 No Homepage yet"
  end

  get "/items" do
    @items = @account.items.latest.paginate(page: params[:page])

    haml :'items/index'
  end

  get "/most-viewed" do
    @items = @account.items.latest.paginate(page: params[:page])

    haml :'items/index'
  end

  get "/items/new" do
    @item = Item.new(:name => params[:name])

    haml :'items/new'
  end
 
  get "/items/:id" do |id|
    @item = @account.items.find(id)

    haml :'items/show'
  end

  post "/items" do
    @item = current_user.items.build(params[:item])
    
    if @item.save
      logger.error({ location: user_url(@item.user) }.to_json)

      { location: user_url(@item.user) }.to_json
    else
      @item.errors.to_json
    end
  end

  put "/items/:id" do |id|

  end

  delete "/items/:id" do |id|

  end

  get '/friends-items' do
    @items = @account.friends_items.latest.paginate(:page => params[:page])

    haml :'items/index'
  end
end
