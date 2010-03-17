class Main
  get "/replies/new" do
    @item  = Item.find(params[:item_id])
    @reply = Reply.new(:item => @item)

    haml :'replies/new', :layout => false
  end

  post "/replies" do
    content_type 'text/plain'
    
    @reply = Reply.new(params[:reply])
    @reply.sender = current_user
  
    if @reply.save
      { location: user_url(@reply.item.user) }.to_json
    else
      @reply.errors.to_json
    end
  end
end
