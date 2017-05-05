99.times do |n|
	name = Faker::Name.name
	email = "email#{n}@email.com"
	password = "842862"	
	User.create!(
		name: name,
		email: email,
		password: password,
		password_confirmation: password
		)
end
