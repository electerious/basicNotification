this.notification =

	_data: []

	_valid: (data) ->

		if data?

			###
			# Set defaults
			###

			if not data.pin? then		data.pin = false
			if not data.class? then		data.class = ''

			if	not data.icon? or
				data.icon is ''

					return false

			if	not data.text? or
				data.text is ''

					return false

		return false

	_build: (data) ->

		"""
		<div class='notification fadeIn #{ data.class }' data-id='#{ new Date().getTime() }'>
			<a class='#{ data.icon }'></a>
			<p>#{ data.text }</p>
		</div>
		"""

	_setOffset: (decrease) ->

		if notification._data.length isnt 0

			# For each notification do ...
			notification._data.forEach (id, index, array) ->

				element	= $(".notification[data-id='#{ id }']")
				height	= parseInt(element.css('top')) + element.outerHeight()

				offset	= height * (index+1) if decrease is false
				offset	= height * index if decrease is true

				# Set new offset
				element.css '-webkit-transform', "translateY(#{ offset }px)"
				element.css '-mz-transform', "translateY(#{ offset }px)"
				element.css 'transform', "translateY(#{ offset }px)"

	show: (data) ->

		return false if not notification._valid data

		# Build
		html	= notification._build data
		id		= $(html).data('id')

		# Recalculate offset of existing notifications
		notification._setOffset false

		# Add
		notification._data.unshift id
		$('body').append html

		# Remove after click
		$(".notification[data-id='#{ id }']").click ->
			if data.action? then data.action id
			notification.close id, true

		# Remove after timeout
		if data.pin is false
			setTimeout ->
				notification.close id
			, 5000

		# Call callback
		callback(id) if data.callback?

		return id

	close: (id, force) ->

		element = $(".notification[data-id='#{ id }']")

		if $(".notification[data-id='#{ id }']:hover").length isnt 0 and force isnt true
			# Close later
			setTimeout ->
				notification.close id
			, 500
			return false

		# Fade out and remove
		element.removeClass('fadeIn').addClass('fadeOut')
		setTimeout ->
			element.remove()
			elementIndex = notification._data.indexOf id
			notification._data.splice elementIndex, 1
			notification._setOffset true
			return true
		, 300