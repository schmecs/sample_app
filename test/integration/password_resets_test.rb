require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:rebecca)
  end

  test "password resets" do
    get new_password_reset_path # navigate to request form
    assert_template 'password_resets/new' 
    # Invalid email
    post password_resets_path, params: { password_reset: { email: "" } }
    assert_not flash.empty? # should display invalid email error and refresh
    assert_template 'password_resets/new'
    # Valid email
    post password_resets_path,
         params: { password_reset: { email: @user.email } }
    assert_not_equal @user.reset_digest, @user.reload.reset_digest # reset digest should change upon successful request
    assert_equal 1, ActionMailer::Base.deliveries.size # 1 thing delivered
    assert_not flash.empty? # success message
    assert_redirected_to root_url
    # Password reset form
    user = assigns(:user) #what's assigns again? why aren't we using @user?
    # Wrong email
    get edit_password_reset_path(user.reset_token, email: "") # correct token
    assert_redirected_to root_url
    # Inactive user
    user.toggle!(:activated) # switch to not-yet-activated
    get edit_password_reset_path(user.reset_token, email: user.email) # correct
    assert_redirected_to root_url
    user.toggle!(:activated) # switch back to activated
    # Right email, wrong token
    get edit_password_reset_path('wrong token', email: user.email)
    assert_redirected_to root_url
    # Right email, right token
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select "input[name=email][type=hidden][value=?]", user.email # successfully loaded form
    # Invalid password & confirmation
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              "foobaz",
                            password_confirmation: "barquux" } }
    assert_select 'div#error_explanation'
    # Empty password
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              "",
                            password_confirmation: "" } }
    assert_select 'div#error_explanation'
    # Valid password & confirmation
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              "foobaz",
                            password_confirmation: "foobaz" } }
    assert is_logged_in?
    assert_nil user.reload.reset_digest
    assert_not flash.empty?
    assert_redirected_to user
  end

  test "expired token" do
    get new_password_reset_path
    post password_resets_path,
         params: { password_reset: { email: @user.email } }

    @user = assigns(:user)
    @user.update_attribute(:reset_sent_at, 3.hours.ago)
    patch password_reset_path(@user.reset_token),
          params: { email: @user.email,
                    user: { password:              "foobar",
                            password_confirmation: "foobar" } }
    assert_response :redirect
    follow_redirect!
    assert_match "expired", response.body
  end
end