class Main
  helpers do
    include Sinatra::Authorization
  end

  post "/api/v1/items" do
    require_api_user

    @user = User.find_by_login!( params[:login] )
    @item = @user.items.build(params[:item])
    
    if @item.save
      @item.to_json
    else
      { :errors => @item.errors }.to_json
    end
  end
end