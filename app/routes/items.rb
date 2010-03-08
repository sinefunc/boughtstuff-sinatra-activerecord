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
    @items = @account.items.sort(:order => "DESC")

    haml :'items/index'
  end

  get "/items/new" do

  end

  post "/items" do

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
