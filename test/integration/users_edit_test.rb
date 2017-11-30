require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

	def setup
		@user = users(:rebecca)
	end

	test "unsuccessful edit" do
		get edit_user_path(@user)
		assert_template 'users/edit'
		patch user_path(@user), params: { user: { name: "",
																							email: "foo@bar",
																							password: "foo",
																							password_confirmation: "bar" } }
		assert_template 'users/edit'
		assert_select 'form[class="edit_user"]'
		assert_select 'div#error_explanation'
		assert_select 'div.alert', /4/
	end

end
