require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

	test "invalid signup information" do
		get signup_path
		assert_no_difference 'User.count' do
			post signup_path, params: { user: { name: "", email: "user@invalid", 
				password: "foo", password_confirmation: "bar" } }
		end
		assert_template 'users/new'
		assert_select 'form[class="new_user"]'
		assert_select 'div#error_explanation'
		assert_select 'div.alert', /4/
	end

	test "valid signup information" do
		get signup_path
		assert_difference 'User.count', 1 do
			post signup_path, params: { user: { name: "Rails Tutorial", email: "example@railstutorial.org", 
				password: "foobar", password_confirmation: "foobar" } }
		end
		follow_redirect!
		assert_template 'users/show'
		assert is_logged_in?
		assert_not flash.empty?
		assert_select 'div.alert-success', count: 1
	end
end
