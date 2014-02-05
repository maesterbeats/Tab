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


#==============================================================================
#						PARSE TAB
#==============================================================================
#
# @param: txt			Takes a formatting intact block of text for
#						processing.
#
# Returns: ParsedTab		Parsed Tab.... An array of note objects.
#---------------------------------------------------------------------
#
# SEE PROCESS LINE for details on format of ParsedTab.
#
#	This funciton, Parse Tab, should be the single entrypoint to the tab
#	parser.
#
#---------------------------------------------------------------------
# TODO:
#
#	- Handle String Names
#
#	- Handle Lines with tab intersperced with other content...
#
#	- Remove like 90% of the commenting...
#
#	- Replace the generic note object being pushed into the
#		results array with a custom Note object class...
#		That way it can have an SVG drawing api, a midi API
#		ect... without having to write adapters all over the
#		place, just update the getter/setters on the note
#		object prototype/ optionaly extend it for each use case
#
#==============================================================================
Parser = () ->

	parseTab = (txt)->


		#-----------------------------------------------
		#		Pre process tab
		#----------------------------------------------

		splitText = txt.split "\n"

		try
			filteredText = strip_non_Tab(splitText)

			if filteredText.length % 6 isnt 0
				throw new Error("bad num of tab lines")

		catch error
			console.log error

		finally
			extras = filteredText.length % 6
			addLines = 6 - extras
			for i in [0...addLines]
				filteredText.push("--------")

		gtrStrings = flattenLines(filteredText)


		#-----------------------------------------------
		#		Parse it......
		#-----------------------------------------------

		ParsedTab = (processLine(_string) for _string in gtrStrings)



		return ParsedTab





	#------------------------------------------------------------------------
	#						STRIP NON TAB LINES
	#------------------------------------------------------------------------
	#
	# @param: lines 			an array of strings to be searched and filtered
	#
	# RETURNS: Filtered		returns a filtered array of strings whos
	#						contents are valid guitar tab
	#
	#------------------------------------------------------------------------


	strip_non_Tab = (lines)->

		#------------------------------------------------
		# Returns true on POSTIVE match
		#------------------------------------------------
		enough_dashes = (line, minDashes)->
			_match = line.match /-/g
			if _match? and _match.length > minDashes
				true
			else
				false

		#------------------------------------------------
		# Returns true on NEGATIVE match
		#------------------------------------------------
		noWords = (line)->
			_match = line.match /[a-z]{4,100}/g
			not _match

		#------------------------------------------------
		# This Essentialy just a handler function for
		# the tab tests. It applies each tab test to each
		# line and allows only those that pass all the
		# tests to added to the returned array
		#------------------------------------------------

		Filtered = _.filter lines, (line)->
			dashTest = enough_dashes(line,4)
			wordTest = noWords(line,4)
			dashTest and wordTest


		return Filtered






	#------------------------------------------------------------------------
	#						FLATTEN LINES
	#------------------------------------------------------------------------
	#
	# @param: lines			an array of strings containing valid guitar tab
	#
	# RETURNS: Strings		An array with six elements, each of which
	#						corresponds to one of the 6 guitarStrings
	#
	# Unraveling the vertical formatting of user input into a continuous
	# horizontal representation. It uses a (i modulo 6) operation to
	# decide which of the six gtrStrings the current string should be
	# appended to.
	#-----------------------------------------------------------------------


	flattenLines = (lines)->
		Strings = ([] for i in [0..5])
		for line,i in lines
			idx = i % 6
			Strings[idx] += line
		return Strings





	#------------------------------------------------------------------------
	#						PROCESS LINE
	#------------------------------------------------------------------------
	#
	# @param: tab			A single Guitar string containing valid tab
	#
	# Returns: Results		An array of Note Objects each of which has
	#						the following:
	#
	#						prefixes: 	Prefix articulation symbols
	#						fretNum: 	The fret Number
	#						postfixes: 	Postfix articulation symbols
	#						duration:	The number of dashes untill
	#									the next note
	#-----------------------------------------------------------------------



	class barStartError extends Error
		constructor: (message)->
			@name = "barStartError"
			@message = message or "Default Message"

	class barEndError extends Error
		constructor: (message)->
			@name = "barEndError"
			@message = message or "Default Message"


	processLine = (tab)->

		Results = []

		try
			if tab[0] isnt "|"
				throw new barStartError("this line doesnt start with a barline...")
		catch error
			console.log error
			tab = "|" + tab

		try
			if tab[tab.length - 1] isnt "|"
				throw new barEndError("this line doesnt end with a barline")
		catch error
			console.log error
			tab += "|"

		_preFixes = [
			"h"
			"p"
			"\\"
			"/"
			"("
			"b"
		]


		sortPre_vs_Post = (rest)->
			[prefix, postfix] = [[],[]]
			for c in rest
				if c in _preFixes
					prefix.push c
				else
					postfix.push c
			[prefix, postfix]


		processPost =(l)->
			post = []
			dash = 0
			bar = ""
			for v in l
				if v is "-"
					dash++
				#else if v in _barLines
				#	bar += v
				else
					post.push v
			[post, dash] #, bar]



		updateResults = (pre, val, kind, post, blank)->
			Results.push
				prefix: pre
				value: val
				kind: kind
				postFix: post
				dur: blank



		split_tab_at_Symbols = (_tab)->
			r = _tab.match /\d\d?[^|0-9]*|:?\|\|?:?[^|0-9]*/g
			if r?
				return r
			else
				return ""



		nameSymbol = (s)->
			fret = s.match /\d\d?/g
			barLine = s.match /:?\|\|?:?/g
			if fret?
				"fret"
			else if barLine?
				"barLine"
			else
				"unknown"



		matches = split_tab_at_Symbols(tab)

		for m in matches

			symbol = m.match(/\d\d?|:?\|\|?:?/g)[0]

			kind = nameSymbol(symbol)

			rest = m.split(symbol)[1].split ""

			pre = prefix

			[prefix, postfix] = sortPre_vs_Post(rest)
			[post, dur] = processPost(postfix)


			updateResults(pre, symbol, kind, post, dur)


		return Results

	return parseTab

@myParser = Parser