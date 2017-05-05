require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
  	@user = users(:michael)  	
  end

  test "unsuccesful edit" do
    log_in_as(@user)
  	get edit_user_path(@user)
  	assert_template "users/edit"
  	patch user_path(@user), params: {user: { name: "", email: "inv", password: "1", password_confirmation: "2"}}
  	assert_template "users/edit"
  	assert_select "div#error_explanation"
  	assert_select "div.alert", {text: "The form contains 4 errors."}
  end

  test "successful edit" do
    log_in_as(@user)
  	get edit_user_path(@user)
  	assert_template "users/edit"
  	name = "Kamil"
  	email = "kamil@email.com"
  	patch user_path(@user), params: { user: { name: name, email: email, password: "", password_confirmation: ""}}
  	assert_redirected_to @user
  	follow_redirect!
  	assert_not flash.empty?
  	@user.reload
  	assert_equal name, @user.name
  	assert_equal email, @user.email
  end

  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    name = "Foo"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name: name, email: email, password: "", password_confirmation: "" } }
    assert_redirected_to @user
    follow_redirect!
    assert_not flash.empty?
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end



end
