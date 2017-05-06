require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup information" do
  	get signup_path
  	assert_no_difference "User.count" do
  		post users_path, params: {
  			user: {
  				name: "",
  				email: "invalid@user",
  				password: "foo",
  				password_confirmation: "fooobar"
  			}
  		}
  	end
  	assert_template "users/new"
    assert_select "div#error_explanation"
    assert_select "div.alert"
  end

  test "valid signup information" do
    get signup_path
    assert_difference "User.count" do
      post users_path, params: {
        user: {
          name: "emre",
          email: "emre@emre.com",
          password: "842862",
          password_confirmation: "842862"
        }
      }
    end
    follow_redirect!
    # assert_template "users/show"    
    # assert is_logged_in?
    # assert_select "div.alert-success"
    assert_not flash.empty?
  end

  test "valid signup with account activation" do
    get signup_path
    assert_difference "User.count", 1 do
      post users_path, params: {
        user: {
          name: "ayla",
          email: "ayma@mynet.com",
          password: "842862",
          password_confirmation: "842862"
        }
      }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    log_in_as(user)
    assert_not is_logged_in?
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not is_logged_in?
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template "users/show"    
    assert is_logged_in?
  end



end
