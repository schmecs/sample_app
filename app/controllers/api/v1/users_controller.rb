class Api::V1::UsersController < ApplicationController

	def show
  	@user = User.find(params[:id])
    render json: @user, serializer: Api::V1::UserSerializer
  end

  def index
    @users = User.where(activated: true)
    render json: @users, each_serializer: Api::V1::UserIndexSerializer
  end

end