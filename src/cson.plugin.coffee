# Export Plugin
module.exports = (BasePlugin) ->
	# Define Plugin
	class CsonPlugin extends BasePlugin
		# Plugin Name
		name: 'cson'

		# Plugin Configuration
		config:
			indent: false

		# =============================
		# Events

		# Render
		# Called per document, for each extension conversion. Used to render one extension to another.
		render: (opts,next) ->
			# Prepare
			config = @config
			{inExtension,outExtension} = opts

			# CSON to JSON
			if inExtension is 'cson' and outExtension in ['json',null]
				# Render and complete
				CSON = require('cson')
				CSON.parse opts.content, (err,obj) ->
					return next(err)  if err
					if config.indent is false
						opts.content = JSON.stringify(obj)
					else if config.indent is true
						opts.content = JSON.stringify(obj,null,4)
					else
						opts.content = JSON.stringify(obj,null,config.indent)
					return next()

			# Something else
			else
				# Nothing to do, return back to DocPad
				return next()
