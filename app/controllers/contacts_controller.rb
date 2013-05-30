class ContactsController < ApplicationController

	def create
		email = params[:contact][:email]
		email = 'invalid' if email.blank?

		user = User.where( email: email ).first || 
				User.new( email: email, full_name: params[:contact][:name], ip: request.ip )

		if user.save
			contact = Contact.new( params[:contact] )
			contact.user = user
			if contact.save
				pop_flash "Thanks for contacting us #{params[:contact][:name]}!"
				redirect_to root_path
			else
				pop_flash "Could not save message.", :error, contact
				render new_contact_path
			end
		else
			pop_flash "Could not save message.", :error, user
			render new_contact_path
		end
			
		
	end

	def index
		authorize! :manage, Contact
		@contacts = Contact.all
		render layout: 'admin'
	end

	def new
		layout = template_exists?( 'page', 'layouts' ) ? 'page' : 'application'
		render layout: layout
	end

	def show
		@contact = Contact.where( id: params[:id] ).last
		render layout: 'admin'
	end

end