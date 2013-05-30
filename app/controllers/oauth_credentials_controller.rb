class OauthCredentialsController < Devise::OmniauthCallbacksController

	def facebook
		auth = request.env["omniauth.auth"]
		credential = OauthCredential.where( provider: auth['provider'], uid: auth['uid'] ).first

		if credential.present?
			# log in the user associated with the credential
			pop_flash "#{credential.user} signed in"

			credential.token = auth['credentials'].token

			sign_in_and_redirect( credential.user )

		elsif @current_user.present?
			credential = @current_user.oauth_credentials.create!( provider: auth['provider'], uid: auth['uid'], token: auth['credentials'].token )
			pop_flash "#{credential.provider} account added."
		else
			user = User.new_from_fb( auth )
			if user.save 
				pop_flash "Facebook registration successful"
				sign_in_and_redirect( user )
			else
				session[:omniauth] = auth.except('extra')
				redirect_to new_user_registration_path
			end
		end

	end


	def twitter
		auth = request.env["omniauth.auth"]
		@auth = auth
		# credential = OauthCredential.where( provider: auth['provider'], uid: auth['uid'] ).first

		# if credential.present?
		# 	# log in the user associated with the credential
		# 	pop_flash "#{credential.user} signed in"
		# 	sign_in_and_redirect( credential.user )
		# elsif @current_user.present?
		# 	credential = @current_user.oauth_credentials.create!( provider: auth['provider'], uid: auth['uid'], token: auth['credentials'].token, secret: auth['credentials'].secret )
		# 	pop_flash "#{credential.provider} account added."
		# else
		# 	user = User.new
		# end

	end


end