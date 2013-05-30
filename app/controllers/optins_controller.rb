class OptinsController < ApplicationController

	skip_before_filter :verify_authenticity_token, :only => [ :create ]


	def create
		email = params[:optin][:email]
		email = 'invalid' if email.blank?
		
		user = User.where( email: email ).first || 
				User.new( email: email, full_name: params[:optin][:name], ip: request.ip )

		if user.save
			goal = user.goals.create( name: params[:optin][:goal], status: 'collected' )
			chimp = Gibbon.new
			list_id = chimp.lists( list_name: 'General' )['data'].first['id']
			res = chimp.list_subscribe( { id: list_id, email_address: user.email, 
						merge_vars: { 'FNAME' => user.first_name, 'LNAME' => user.last_name, 
							'OPTIN_IP' => user.ip, 'GOAL' => goal.name,
							'MC_LOCATION' => { 'LATITUDE' => nil, 'LONGITUDE' => nil } },
						:email_type => "html",  :double_optin => false } )

			record_app_event( 'optin', on: @current_site, user: user, content: "opted in." ) if res

			pop_flash "Thanks for signing up #{params[:optin][:name]}!"
		else
			pop_flash "Could not sign up", :error, user
		end
			
		redirect_to :back
	end

end