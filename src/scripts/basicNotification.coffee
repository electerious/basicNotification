this.basicNotification =

	_data: []

	_dom: (id) ->

		if not id? then return $('.basicNotification')
		else return $(".basicNotification[data-id='#{ id }']")

	_valid: (data) ->

		if data?

			###
			# Set defaults
			###

			if not data.id? then		data.id = new Date().getTime() + Math.round(Math.random()*1000)
			if not data.pin? then		data.pin = false
			if not data.class? then		data.class = ''
			if not data.icon? then		data.icon = ''
			if not data.text? then		data.text = 'Undefined'

			return true

		return false

	_build: (data) ->

		"""
		<div class='basicNotification basicNotification--fadeIn #{ data.class }' data-id='#{ data.id }'>
			<a class='#{ data.icon }'></a>
			<p>#{ data.text }</p>
		</div>
		"""

	_setOffset: (decrease) ->

		if basicNotification._data.length isnt 0

			# For each notification do ...
			basicNotification._data.forEach (id, index, array) ->

				element	= basicNotification._dom(id)
				height	= parseInt(element.css('top')) + element.outerHeight()

				offset	= height * (index+1)	if decrease is false
				offset	= height * index		if decrease is true

				# Set new offset
				element.css '-webkit-transform', "translateY(#{ offset }px)"
				element.css '-mz-transform', "translateY(#{ offset }px)"
				element.css 'transform', "translateY(#{ offset }px)"

	show: (data) ->

		return false if not basicNotification._valid data

		# Build
		html = basicNotification._build data

		# Recalculate offset of existing notifications
		basicNotification._setOffset false

		# Add
		basicNotification._data.unshift data.id
		$('body').append html

		# Remove after click
		basicNotification._dom(data.id).click ->
			if data.action? then data.action data.id
			basicNotification.close data.id, true

		# Remove after timeout
		if data.pin is false
			setTimeout ->
				basicNotification.close data.id
			, 5000

		# Call callback
		callback(data.id) if data.callback?

		return data.id

	close: (id, force) ->

		element = basicNotification._dom(id)

		if $(".basicNotification[data-id='#{ id }']:hover").length isnt 0 and force isnt true
			# Close later
			setTimeout ->
				basicNotification.close id
			, 500
			return false

		# Fade out and remove
		element.removeClass('basicNotification--fadeIn').addClass('basicNotification--fadeOut')
		setTimeout ->
			element.remove()
			elementIndex = basicNotification._data.indexOf id
			basicNotification._data.splice elementIndex, 1
			basicNotification._setOffset true
			return true
		, 300