class ItemsController < ApplicationController
  def index
    
  end
  
  def new
    @item = Item.new( params[:item] )
  end
  
  
  def create
    @item = current_user.items.build( params[:item] )
    
    if @item.save
      flash[:success] = "You have successfully posted an item."
      redirect_to dashboard_path
    else
      render 'new'
    end
  end
end
