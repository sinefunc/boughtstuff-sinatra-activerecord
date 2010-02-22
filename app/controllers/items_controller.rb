class ItemsController < ApplicationController
  login_required

  def index
    render :text => "hoy"
  end

  def create
    @item = Item.new(params[:item])
    @item.save!

    redirect_to edit_item_path(@item)
  end

  def edit
    @item = Item.find(params[:id])
  end
end
