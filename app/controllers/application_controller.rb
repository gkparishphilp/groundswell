class ApplicationController < ActionController::Base
	protect_from_forgery
	layout 'application'

	before_filter :initialize_session

	rescue_from CanCan::AccessDenied do |exception|
    	flash[:error] = exception.message
    	redirect_to "/"
  	end

  	def after_sign_in_path_for( resource )
 		if resource.has_role?( :admin )
 			return '/admin'
 		elsif resource.provider.present?
 			return provider_home_path
 		else
 			return user_home_path
 		end
	end

  	# over-ride CanCan's method to use @current_user
	def current_ability
		return Ability.new( User.new ) if @current_user.nil?
		@current_ability ||= Ability.new( @current_user )
	end


	def record_app_event( event='view', args={} )
		# this method can be called by any controller to log a specific event
		# such as a purchase, comment, newsletter signup, etc.
		event = event.to_s
		args[:request] ||= request
		args[:site] ||= @current_site
		args[:user] ||= @current_user
		args[:participant_id] ||= cookies[:pid]

		return AppEvent.record( event, args )

	end


	private

		def cookie_referrer
			ref_user = User.where( name: params[:ref] ).first || User.where( id: params[:ref] ).first
			ref_id = ref_user.try( :id )
			# referrer cookie is always user.id
			cookies[:referrer] = { :value => ref_id, :expires => 30.days.from_now } if ref_user.present?
			return ref_id
		end
		

		def initialize_session
			@current_site = initialize_site
			@current_user = initialize_user
			ref_id = cookie_referrer
			record_app_event( :visit, on: @current_site, rate: 16.hours, content: "visited #{@current_site}", ref: ref_id )
			
			set_metatags
		end


		def initialize_site
			site = Site.where( domain: request.domain ).last || Site.where( is_app_host: true ).last
			if site.is_app_host? && request.subdomain.present?
				site = Site.where( name: request.subdomain ).last
			end
			site ||= Site.app_host
			return site
		end

		def initialize_user
			# if using Devise
			return current_user
		end

end
