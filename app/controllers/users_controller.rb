class UsersController < ApplicationController
	before_filter :authenticate_user!

	def home
		@goal_assignments = @current_user.assignments.where( assigned_type: 'Goal', status: 'active' )
		@activity_assignments = @current_user.assignments.where( assigned_type: 'Activity', status: 'active' )
		@stat_assignments = @current_user.assignments.where( assigned_type: 'Stat', status: 'active' )
		render layout: 'user_admin'
	end
	
	def settings
		render layout: 'user_admin'
	end

	def update
		# for settings

	end
end