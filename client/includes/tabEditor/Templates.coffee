paper = null

Template.tabInput.events =
	'submit form': (e)->
		e.preventDefault()
		tab = $(e.target).find('[name=message]').val()
		t = tabParser tab
		Session.set 'userTab', t

Template.showTab.rendered = ->
	paper = Raphael 'canvas_container'