# Export Plugin
module.exports = (BasePlugin) ->
	# Define Plugin
	class CsonPlugin extends BasePlugin
		# Plugin Name
		name: 'cson'

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

				# Parse CSON
				result = CSON.parseCSONString(opts.content)
				return next(result)  if result instanceof Error

				# Create JSON
				result = CSON.createJSONString(result, config)
				return next(result)  if result instanceof Error

				# Apply
				opts.content = result

				# Complete
				return next()

			# Something else
			else
				# Nothing to do, return back to DocPad
				return next()
