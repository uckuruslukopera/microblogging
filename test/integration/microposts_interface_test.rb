require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  
  	def setup
  		@user = users(:michael)
  	end

	test "micropost interface" do
		log_in_as(@user)
		get root_path
		assert_select "div.pagination"
		assert_select "input[type=file]"
		#invaild
		assert_no_difference "Micropost.count" do
			post microposts_path, params: { micropost: {content: ""}}
		end
		assert_select "div#error_explanation"
		#valid
		assert_difference "Micropost.count", 1 do
			post microposts_path, params: { micropost: {content: "roomie", picture: fixture_file_upload("test/fixtures/testp.jpg", "image/jpg")}}
		end		
		assert assigns(:micropost).picture?
	 	assert_redirected_to root_url
		follow_redirect!
		
		assert_match "roomie", response.body
		#delete
		assert_select "a", text: "delete"
		first_mp = @user.microposts.paginate(page: 1).first
		assert_difference "Micropost.count", -1 do
			delete micropost_path(first_mp)
		end
		#visit diff user
		get user_path(users(:archer))
		assert_select "a", text: "delete", count: 0
	end

	




end
