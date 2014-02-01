Router.configure
	autoRender: false
	layoutTemplate: 'layout'
	notFoundTemplate: 'notFound'
	loadingTemplate: 'loading'

Router.map ->
	@route 'home',
		path: '/'
		template: 'home'
		layoutTemplate: 'layout'
		yieldTemplates:
			'sidebar': to: 'sidebar'
