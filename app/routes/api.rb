class Main
  helpers do
    include Sinatra::Authorization
  end

  post "/api/v1/items" do
    require_api_user

    begin
      @user = User.find_by_login!( params[:login] )
    rescue ActiveRecord::RecordNotFound
      "User not found #{params[:login]}"
    else
      @item = @user.items.build(params[:item])
      
      if @item.save
        @item.to_json
      else
        { :errors => @item.errors }.to_json
      end
    end
  end
end
