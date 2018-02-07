require 'test_helper'

class Api::V1::UsersControllerTest < ActionDispatch::IntegrationTest
  
	def setup
		@user = users(:rebecca)
		@other_user = users(:archer)
	end

  # api

  test "returns a single user" do  
    get api_v1_user_path(@user)
    assert response.status == 200
    json = JSON.parse(response.body)
    assert json['id'] == @user.id
    assert json['email'] == @user.email
  end

end
