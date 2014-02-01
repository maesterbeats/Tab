Meteor.startup ->
	@tabParser = new myParser
	Session.setDefault 'userTab', null


Deps.autorun ->
	t = Session.get 'userTab'
	paper.score(t) if paper?

###
	coffeescript is going to automaticaly make paper a localy (file) scoped var
        Ive tried adding @paper to give it global scope but it doesnt work.

        The problem is deps.autorun Template.showTab.rendered both need a reffrence to paper so I'm forced to keep them in the same file.
        I thought of storing the reffrence to paper in the session object but it doesnt seem like i can put it there... it keeps
        coming up with errors.
###

paper = null


Template.tabInput.events =
	###
		Make entire form element reactive so the tab is rerendered without using submit.
	###
	'submit form': (e)->
		e.preventDefault()
		tab = $(e.target).find('[name=message]').val()
		t = tabParser tab
		Session.set 'userTab', t

Template.showTab.rendered = ->
	paper = Raphael 'canvas_container'







