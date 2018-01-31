class Api::V1::UsersController < ApplicationController

	def show
  	@user = User.find(params[:id])
    @microposts = @user.microposts
    render json: @user
  end

end