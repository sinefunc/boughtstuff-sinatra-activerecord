class Main
  post '/retweets' do
    @item           = Item.find(params[:item_id])
    @retweet        = Retweet.new(:item => @item)
    @retweet.sender = current_user
    @retweet.save
  end

  get '/retweets' do
    @item = Item.find(params[:item_id])

    haml :'retweets/success', :layout => false
  end
end
