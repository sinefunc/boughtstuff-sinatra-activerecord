class Main
  helpers do
    def current_account 
      @account ||= User.find_by_username( params[:username] ) || AnonymousUser.new
    end
  end

  get '/' do
    redirect '/everyone'
  end

  resource 'everyone' do |everyone|
    everyone.index do
      @items = current_account.items.latest.paginate(page: params[:page])
      @page_title = "Everyone's Items"

      haml :'items/index'
    end

    everyone.get 'most-viewed' do
      @items = current_account.items.most_viewed.paginate(page: params[:page])
      @page_title = "Most Popular Items"

      haml :'items/index'
    end

    everyone.get 'liked' do
      @items = current_account.likes_items.paginate(page: params[:page])
      @page_title = "Most Liked Items"

      haml :'items/index'
    end

  end

  resource ':username' do |user|
    user.index do
      if User === current_account
        @items = current_account.items.latest.paginate(page: params[:page])
        @page_title = "#{current_account.name}'s Shelf"

        haml :'items/index'
      else
        pass
      end
    end

    user.get 'tagged/:tag' do |username, tag|
      @items = current_account.items.tagged(params[:tag]).paginate(page: params[:page])
      @page_title = "#{current_account.name}'s Shelf | Tagged #{params[:tag]}"

      haml :'items/index'
    end

    user.get 'most-viewed' do
      @items = current_account.items.most_viewed.paginate(page: params[:page])
      @page_title = "#{current_account.name}'s Shelf | Most Viewed"

      haml :'items/index'
    end

    user.get 'liked' do
      @items = current_account.likes_items.latest.paginate(page: params[:page])
      @page_title = "#{current_account.name}'s Liked Items"

      haml :'items/index'
    end

    user.get 'friends-items' do
      @items = current_account.friends_items.latest.paginate(page: params[:page])
      @page_title = "#{current_account.name} | Friend's Items"

      haml :'items/index'
    end

    user.get ':id' do 
      pass unless User === current_account
      
      @item = @account.items.find(params[:id])
      @item.viewed!
      @page_title = "#{current_account.name} | #{@item.name}"
        
      haml :'items/show'
    end

    user.delete ":id" do 
      login_required
      
      content_type 'text/plain'
      
      @item = current_user.items.find(params[:id])
      @item.destroy
      
      { :location => user_url(@item.user) }.to_json
    end
  end

  resource 'items' do |items|
    items.new do
      login_required

      @item = Item.new(:name => params[:name])
      @page_title = "Post a new Item"

      haml :'items/new'
    end

    items.create do
      login_required
      
      content_type 'text/plain'
      
      @item = current_user.items.build(params[:item])
      
      if @item.save
        { location: user_url(@item.user) }.to_json
      else
        @item.errors.to_json
      end
    end
  end
end
