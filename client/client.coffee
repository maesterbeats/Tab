Meteor.startup ()->
	@tabParser = new myParser
	Session.setDefault 'userTab', off

Deps.autorun ()->
	t = Session.get 'userTab'
	paper.score(t) if paper?

paper = null

Template.tabInput.rendered = ()->
	paper = Raphael 'canvas_container'


Template.tabInput.events =
	'submit form': (e)->
		e.preventDefault()
		tab = $(e.target).find('[name=message]').val()
		t = tabParser tab
		Session.set 'userTab', t