class HomepageController < ApplicationController
	before_filter :get_terms

	def index
		@tagline = ["Be Better Together", "Life is a Team Sport", "What Will You Be?", "Believe It and Achieve It" ].sample( 1 ).first
		@tagline = "Because Life is a Team Sport"
		render layout: 'homepage'
	end

	def pros
		render layout: 'homepage'
	end

	def sitemap
		redirect_to "https://s3.amazonaws.com/begoaled/sitemaps/sitemap_index.xml.gz"
	end


	private

		def get_terms
			@terms = %w[Active
			Aggressive
			Alert
			Alive
			Ambitious
			Amazing
			Amped
			Assured
			Authentic
			Beautiful
			Better
			Big
			Bold
			Brave
			Committed
			Courageous
			Crafty
			Creative
			Daring
			Deliberate
			Delightful
			Diligent
			Dominant
			Earnest
			Effective
			Empowered
			Energetic
			Engaged
			Exciting
			Exemplary
			Farsighted
			Fast
			Fierce
			Friendly
			Fulfilled
			Genuine
			Graceful
			Great
			Happy
			Helpful
			Honest
			Huge
			Improved
			Informed
			Intense
			Kind
			Lovely
			Motivated
			Mindful
			Positive
			Powerful
			Proud
			Quick
			Real
			Relentless
			Rich
			Rigorous
			Ripped
			Scrappy
			Sharp
			Sincere
			Smart
			Sporty
			Spunky
			Stoked
			Strong
			Successful
			Supportive
			Tenacious
			Thoughtful
			True
			Up
			Well
			Wise
			Wonderful
			You].sample( 7 )
			
			@terms.push( "Goaled" )

		end

end


