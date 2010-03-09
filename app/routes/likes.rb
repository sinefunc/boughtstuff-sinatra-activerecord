class Main
  post "/likes" do
    @like = current_user.likes.create(:item_id => params[:item_id])
    @like.id
  end

  delete "/likes/:id" do |id|
    @like = current_user.likes.find_by_item_id(params[:id])
    @like.destroy
  end
end
