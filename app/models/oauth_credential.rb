class OauthCredential < ActiveRecord::Base
	attr_protected :none
	
	belongs_to :user
	
end