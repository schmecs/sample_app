require 'test_helper'

class Api::V1::UsersControllerTest < ActionDispatch::IntegrationTest
  
	def setup
		@user = users(:rebecca)
		@other_user = users(:archer)
    @inactive_user = users(:lana)
	end

  # api

  test "returns a single user with all microposts and followers when user exists" do  
    get api_v1_user_path(@user)
    assert response.status == 200
    json = JSON.parse(response.body)
    assert json['id'] == @user.id
    assert json['email'] == @user.email
    assert json['microposts'].length == @user.microposts.length
    assert json['followers'].length == @user.followers.length
    assert json['following'].length == @user.following.length
    assert json['followers'].last['id'] == @user.followers.last.id
  end

  test "should return 404 when user is not found" do
    user_id = User.last.id + 100
    get "http://localhost:3000/api/v1/users/#{user_id}"
    assert response.status == 404
    # return a "User not found" message
    assert_match "User not found", response.body
  end

  test "index should return all active users" do  
    get api_v1_users_path
    assert response.status == 200
    assert json.length == User.where(activated: true).count
    user_ids = json.map{|u| u[:id]}
    assert user_ids.include?(@other_user.id)
    assert_not user_ids.include?(@inactive_user.id)
  end

end
