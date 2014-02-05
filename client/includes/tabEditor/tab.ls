/**
 * User: andrewstern
 * Date: 2/2/14
 * Time: 9:02 804PM
 */

/*
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


*/

valid-tab = //(
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
	)//

newLine = /\n/
tab
|> split newLine
|>