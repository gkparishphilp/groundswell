$ ->

	$('.hover-toggled').css 'display', 'none'

	$('.hover-toggler').hover(
		->
			$(@).find('.hover-toggled').show()
		->
			$(@).find('.hover-toggled').hide()
	)

	if $( '#media_status' ).val() isnt 'redirect'
		$( '#redirect_path' ).css( 'display', 'none' )


	$( '#media_status' ).change ->
		if $(@).val() is 'redirect'
			$('#redirect_path').show( 800 )
		else
			$('#redirect_path').hide( 800 )


	# Thsi should all move to tests engine, just slamming in here for testing
	if $( '#test_conversion_event' ).val() isnt 'view'
		$( '#conversion_path_select' ).css( 'display', 'none' )

	$( '#test_conversion_event' ).change ->
		if $(@).val() is 'view'
			$('#conversion_path_select').show( 800 )
		else
			$('#conversion_path_select').hide( 800 )