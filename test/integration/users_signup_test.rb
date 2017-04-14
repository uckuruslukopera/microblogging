require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
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
    assert_template "users/show"
    assert_select "div.alert-success"
    assert_not flash.empty?
  end
end
