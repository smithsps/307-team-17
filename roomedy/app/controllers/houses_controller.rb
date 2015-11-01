class HousesController < ApplicationController
 	before_action :logged_in_user
 	before_action :is_admin, only: [:edit, :update]

 	def show
		@house = House.find(params[:id])
	end
	def new
		@house = House.new
  	end
	def create
		@house = House.new(house_params)
		@house.permissions.build
		@relationship = Relationship.create()
		current_user.relationship = @relationship
		@house.relationships << @relationship
		# @house.permissions << @perm_default
		# @house.permissions << @perm_user
		if @house.save
			@house.permissions.create(user_id: 0, level: 1)
			@house.permissions.create(user_id: current_user.id, level: 0)
			if current_user.save(validate: false)
				flash[:success] = "Welcome to your new Home, #{current_user.name}"
			else
				flash[:notice] = "Unable to save user"
			end
			redirect_to @house
		else
			render 'new'
		end
	end

	def edit
		@house = House.find(params[:id])
	end

	def update
		@house = House.find(params[:id])
		if @house.update_attributes(house_params)
			flash[:success] = "House information updated"
			redirect_to @house
		else
			render 'edit'
		end
	end

	private
		def house_params
			params.require(:house).permit(:name, :street, :city, :state, :zip)
		end

		def is_admin
			@house = House.find(params[:id])
			if @house.permissions.find_by user_id: current_user.id
				perm = @house.permissions.find_by user_id: current_user.id
			else
				perm = @house.permissions.first
			end

			unless perm.level == 0
				flash[:danger] = "#{perm.level}. You must be the house administrator to view this page"
				redirect_to @house
			end
		end
end
