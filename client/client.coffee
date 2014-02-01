Meteor.startup ()->
	@tabParser = new myParser
	Session.setDefault 'userTab', null

Deps.autorun ()->
	t = Session.get 'userTab'
	paper.score(t) if paper?







