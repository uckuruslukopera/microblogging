if (Rails.env.test? || Rails.env.development?)
	CarrierWave.configure do |config|
		config.enable_processing = false
	end
end