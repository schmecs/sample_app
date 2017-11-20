require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

	def setup
		@user = users(:rebecca)
	end

	test "failed login should reload login and show flash" do
		get login_path
		assert_template 'sessions/new'
		post login_path, params: { session: { email: "not@user", 
			password: "foo", } }
		assert_template 'sessions/new'
		assert_not flash.empty?
		get root_path
		assert flash.empty?
	end

	test "successful login should update params and redirect to user profile" do
		get login_path
		post login_path, params: { session: { email: @user.email,
			password: 'password' } }
		assert_redirected_to @user
		follow_redirect!
		assert_select "a[href=?]", login_path, count: 0
		assert_select "a[href=?]", logout_path
		assert_select "a[href=?]", user_path(@user)
	end

end
