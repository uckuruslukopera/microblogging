User.create!(
	name: "Merve T.",
	email: "loginquitas@gmail.com",
	password: "842862",
	password_confirmation: "842862",
	admin: true,
	activated: true,
	activated_at: Time.zone.now
	)


99.times do |n|
	name = Faker::Name.name
	email = "email#{n}@email.com"
	password = "842862"	
	User.create!(
		name: name,
		email: email,
		password: password,
		password_confirmation: password,
		activated: true,
		activated_at: Time.zone.now
		)
end

users = User.order(:created_at).take(6)
50.times do
	content = Faker::Lorem.sentence(5)
	users.each {
		|user| user.microposts.create!(content: content)
	}
end

users = User.all
user = User.first

following = users[2..50]
followers = users[3..40]

following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }
