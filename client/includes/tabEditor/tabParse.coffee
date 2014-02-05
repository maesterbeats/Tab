
###
	------------------------------ Regex Helpers ----------------------------------------

	TODO:

		- update joinRegex to accept flags
		- figure out why regexJoin works even though its return a string....
		- add a dontCapture() wrapper similar to optional()
		- isWrapped() is kind of a mess...
###

Raphael.fn.score = (tab)->
	@_score = for staff,j in tab
		for _string,y in staff
			dy = (y * 10) + ((j * 100) + 10)
			@path( ["M", 0, dy, "H", 775, "Z" ] ).attr
				'stroke': Raphael.color('grey')
			for note,x in _string
				dx = (x * 10) + 25
				@text( dx, dy, note ).attr
					'font-size': 14
	return @_score


Parser = () ->
	isWrapped = (r) ->
		###
		This feels like an aweful hackey way
		to go about validating regex expressions

		###
		oParen = /\(/
		cParen = /\)/
		backSlash = /\\/
		re = r.source.split ""
		unMatched = 0
		escaped = off
		wrapped = -1
		if re[0] isnt "("
			return false
		else if re[re.length - 1] isnt ")"
			return false
		for c,i in re
			if escaped is on
				escaped = off
			else if escaped is off
				if oParen.test c
					unMatched++
				else if cParen.test c
					unMatched--
				else if backSlash.test c
					escaped = on
			if unMatched is 0
				if i < (re.length - 1)
					return false
				else if i is (re.length - 1)
					return true
		return false



	optional = (re)->
		if isWrapped(re)
			new RegExp re.source + "?"
		else
			new RegExp "(#{re.source})?"



	joinRegex = (regs...)->
		###
		add optional -flag argument...

		also, this is currently just returning a
		concatenated string and not an actual regex
		object so its a bit strange that it seems
		to be working as an argument to string.match
		... string.match should take a regex obj or
		a regex literal as an argument. Maybe
		there is some sort of type coersion going on
		under the hood.... Anyways im not going to
		go messing with it untill i have time to
		dig in and really understand it since its
		working as is.
		###
		regArray = (reg.source for reg in regs).join ""
		new RegExp regArray




	###
	------------------------------ Regex Deffs ----------------------------------------

	TODO:
		- add regex expressions for special characters like hammer-on ect...
		- capture extra annotations like X2 (for repeat twice)
		- capture form annotations like Chorus, Verse, Solo ect...
		- support for interleaved staffs? i.e. guitar1 & guitar2


	###

	line_start = /(\|{1,2}:?)/	# match | or || or |: or ||:

	line_end = /(:?\|{1,2})/		# match :| or :|| or | or ||


	mid_line = ///(
		(
			:(\|{1,2}:)	# matches :|: or :||:
		)
		| 	# ...or...
		(
			\|{1,2}		# matches | or ||
		)
	)///

	valid_tab = ///(
		([0-2]?[0-9])?	# optional 0-24
		(				# all of the flowing at least once "+"
			-+				# one or more "-"
			(
				([0-2]?[0-9])
				|				# optional 0-24
				[a-z]				# 0-2 letters
				|
				/
			)*
		)+
	)///

	string_names = /(e|a|d|g|b|E|A|D|G|B)/





	###
	------------------------------ Parser ----------------------------------------

	TODO:
		- error handling
		- currently mistakes any line with 1 or more "-" as tab... no bueno
		- support for rhymic notation. currently none
		- handle ber delimiters, repeat signs ect...


	###




	_groupBySix = (lines)->
		_grabSix = (lines)-> [lines[..5], lines[6..]]
		###
			Need a better way to handle the case
			when lines.length isnt divisible by 6
			maybe throw and error, ask the user to
			correct the missing and/or extra lines
			ect...
		###
		numBars = Math.ceil lines.length/6
		bars = []

		for i in [1..numBars]
			x = _grabSix(lines)
			bars.push x[0]
			lines = x[1]
		return bars


	tab_parts = [
		optional string_names
		optional line_start
		valid_tab
		optional mid_line
		optional line_end
	]

	tab_pattern = joinRegex tab_parts...

	start_stuff = joinRegex [string_names, line_start]


	parseTab = (tab)->
		tab = tab.split "\n"
		_t = for line in tab
			m = line.match tab_pattern, "g"
			r = if m? then m[0]
		x = (line for line in _t when line isnt undefined)
		_tab = _groupBySix x
		new_tab = for bar in _tab
			for string in bar
				###
					Im evenutaly planning to use the
					regexJoin constructor
					to perform the following...
					but I havent gotten around
					to finishing it yet....

					Also, this implementation is dumb
					and doesnt account for bar divisions
					mid-line. also on the to-do list
				###
				s = string.replace /^\w/g, ""
				s = s.replace /(\|{1,2}:?)?/g, ""
				s = s.replace /-/g, " "
				s.split ""


@myParser = Parser




