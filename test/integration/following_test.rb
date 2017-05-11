require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest
	def setup
		@user = users(:michael)
		@other = users(:archer)
		log_in_as @user	
	end

	test "following page" do
		get following_user_path(@user)
		assert_not @user.following.empty?
		assert_match @user.following.count.to_s, response.body
		@user.following.each do |user|
			assert_select "a[href=?]", user_path(user)
		end
	end

	test "followers page" do
		get followers_user_path(@user)
		assert_not @user.followers.empty?
		assert_match @user.followers.count.to_s, response.body
		@user.followers.each do |user|
			assert_select "a[href=?]", user_path(user)
		end
	end

	test "should follow a user the standart way" do
		assert_difference "Relationship.count", 1 do
			post relationships_path, params: { followed_id: @other.id }
		end
	end

	test "Should follow a user ajax way" do
		assert_difference "Relationship.count", 1 do
			post relationships_path, params: { followed_id: @other.id }, xhr: true
		end
	end

	test "should unfollow a user the standart way" do
		@user.follow(@other)
		relationship = @user.active_relationships.find_by(followed_id: @other.id)
		assert_difference "Relationship.count", -1 do
			delete relationship_path(relationship)
		end
	end

	test "should unfollow a user the ajax way" do
		@user.follow(@other)
		relationship = @user.active_relationships.find_by(followed_id: @other.id)
		assert_difference "Relationship.count", -1 do
			delete relationship_path(relationship), xhr: true
		end
	end

	test "feed on home page" do
		get root_path
		@user.feed.paginate(page: 1).each do |micropost|
			assert_match CGI.escapeHTML(micropost.content), response.body
		end
	end


end
