Session.set 'userTab', ""


Deps.autorun ()->
	paper = Raphael 'canvas_container', 800, 250
	# paper.rect 0,0,775,400,20
	tabParser = new myParser

	_t = Session.get('userTab')
	tab = tabParser _t
	for staff in tab
		for _string,y in staff
			dy = (y * 10) + 10
			_s = paper.path( ["M", 0, dy, "H", 775, "Z" ] )
			_s.attr
				'stroke': Raphael.color('grey')
			for note,x in _string
				dx = (x * 10) + 25

				_t = paper.text dx, dy, note
				_t.attr
					'font-size': 14
				_t.toFront()




mtab = """
e|-------------------------------------------------------------------------|
B|----------------5-----------------------------------------5-5------------|
G|--------2-4/6------6/4--2-------2h4p2-----2----4br--4/6-------6/4-----2-2|
D|-2/4----------------------2h4---------4-------------------------2-4------|
A|-------------------------------------------------------------------------|
E|-------------------------------------------------------------------------|
"""


Template.myCanvas.rendered = ()->
	paper = Raphael 'canvas_container', 800, 250
	# paper.rect 0,0,775,400,20
	tabParser = new myParser

	_t = Session.get('userTab')
	tab = tabParser _t
	for staff in tab
		for _string,y in staff
			dy = (y * 10) + 10
			_s = paper.path( ["M", 0, dy, "H", 775, "Z" ] )
			_s.attr
				'stroke': Raphael.color('grey')
			for note,x in _string
				dx = (x * 10) + 25

				_t = paper.text dx, dy, note
				_t.attr
					'font-size': 14
				_t.toFront()




Template.tabInput.events =
	'submit form': (e)->
		e.preventDefault()
		tab = $(e.target).find('[name=message]').val()
		Session.set('userTab', tab)