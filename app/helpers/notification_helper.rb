class NotificationHelper
	def self.notify(id, user, notification_header, notification_body)
		if user.phone_number != nil
			send_sms_message(user.number, notification_body)
		end
		if user.email != nil
			notification_email(user, notification_header, notification_body, "roomedy.com/notify")
		end
	end	

	def self.send_sms_message(number_to_send_to, message)
		twilio_client = Twilio::REST::Client.new Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_auth_token

		twilio_client.messages.create(
		    :from => "+1#{"415-599-2671"}",
		    :to => number_to_send_to,
		    :body => message
		)
	end
end