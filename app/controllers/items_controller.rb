class ItemsController < ApplicationController

    #before_action :logged_in_user
    #before_action :correct_user
    
    ##
    # Here is where I will be doing frequency tracking
    # I'm going to have to change the setup of adding items, for one
    # Because right now adding two items with the same name puts two different entries in the table
    # I will check for uniqueness of the name, and if the name is different then I will create a new one
    # Otherwise, I will add the amount to the existin gitem
    # What is here is stupid basic, and will require a lot of change
    # NOTE: Another option is to have a list of created items to choose from, and then to create a new item if necessary
    
    def new
        @item = Item.new
    end
    
    def create
        @item = current_user.items.build(item_params)
        if @item.save
            @item.prev_amount = @item.item_amount
            @item.frequency = 1
            flash[:success] = "Item Created."
            redirect_to items_path
        else
            render 'new'
        end
    end

    def index
        @items = Item.paginate(page: params[:page])
        @sorteditems = @items.sort_by { |i| i.frequency }
        @top5 = @sorteditems.first(5)
    end
    
    def edit
        @item = Item.find(params[:id])
    end

    def update
         @item = Item.find(params[:id])
         @item.prev_amount = @item.item_amount
         if @item.update_attributes(item_params)
            if @item.prev_amount < @item.item_amount
                @item.frequency += 1
            end
            flash[:success] = "Item successfully updated"
            redirect_to items_path
         else
            render 'edit'
         end
    end
    
    def destroy
        @item = Item.find(params[:id])
        @item.destroy
        flash[:success] = "Item Deleted"
        redirect_to items_path
    end

    private
    	def item_params
			params.require(:item).permit(:item_amount, :item_price, :item_name, :visibility)
		end
		
		def correct_user
		    @item = current_user.items.find_by(id: params[:id])
		    if @item.nil?
              flash[:danger] = "You are not allowed to perform that task on that item."
              redirect_to items_path
            end
	    end
end
