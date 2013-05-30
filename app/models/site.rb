class Site < ActiveRecord::Base
	attr_protected :user_id

	### FILTERS		--------------------------------------------
	before_validation		:set_name, :clean_domain

	### VALIDATIONS	---------------------------------------------
	validates		:name, :uniqueness => true, :format => { :with => /\A[a-zA-Z0-9]+\z/, :message => 'Site name alphanumeric only' }

	### RELATIONSHIPS   	--------------------------------------
	# define this in hostapp
	belongs_to		:owner, :class_name => 'User', :foreign_key => :user_id
	has_many		:users, dependent: :destroy

	### Plugins  	---------------------------------------------

	### Class Methods   	--------------------------------------

	def self.app_host
		Site.where( is_app_host: true ).last
	end

	### Instance Methods  	--------------------------------------

	def homepage
		SwellMedia::Page.where( slug: 'homepage' ).last
	end

	def http_url
		return "http://#{self.url}"
	end

	def to_s
		self.display_name || self.name || self.domain
	end

	def url
		self.domain.present? ? self.domain : "#{self.name}.#{Site.app_host.domain}"
	end

	### Protected   	--------------------------------------
	protected
		# define these in swell_media
		# def create_homepage
		# 	self.pages.create :url => 'homepage', :description => self.description, :title => "Home", :is_title_visible => false, :is_shareable => false, :is_commentable => false, :content => "Under Construction"
		# end

		def set_name
			if self.name.blank?
				if self.display_name.present?
					self.name = self.display_name.gsub( /\W/, "_" ).downcase
				else
					self.name = self.domain.gsub( /\W/, "_" ).downcase
				end
			end
			self.display_name = self.name.to_s.titleize unless self.display_name?

		end

		def clean_domain
			domain.gsub!('http://', '') unless domain.nil?
		end

		def has_domain?
			self.domain.present?
		end

end