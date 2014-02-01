Meteor.startup ->
	@tabParser = new myParser
	Session.setDefault 'userTab', null


Deps.autorun ->
	t = Session.get 'userTab'
	if paper?
		paper.clear()
		paper.score(t)
###
	coffeescript is going to automaticaly make paper a localy (file) scoped var
        Ive tried adding @paper to give it global scope but it doesnt work.

        The problem is deps.autorun Template.showTab.rendered both need a reffrence to paper so I'm forced to keep them in the same file.
        I thought of storing the reffrence to paper in the session object but it doesnt seem like i can put it there... it keeps
        coming up with errors.
###

paper = null

###
        TODO:
                Make multiple view options like chazee said
###

tabEditor = Template.tabInput
_.extend tabEditor,
	events:
		'keyup form': (e)->
			e.preventDefault()
			tab = e.target.value
			console.log tab
			t = tabParser tab
			Session.set 'userTab', t

###

Template.tabInput.events =
	'change form': (e)->
		e.preventDefault()
                tab = $(e.target).find('[name=message]').val()
                t = tabParser tab
                Session.set 'userTab', t

	'submit form': (e)->
		e.preventDefault()
		tab = $(e.target).find('[name=message]').val()
		t = tabParser tab
		Session.set 'userTab', t
###

Template.showTab.rendered = ->
	paper = Raphael 'canvas_container'







