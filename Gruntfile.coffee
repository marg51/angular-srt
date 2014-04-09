module.exports = (grunt) ->
	grunt.loadNpmTasks "grunt-karma"
	grunt.loadNpmTasks "grunt-contrib-coffee"
	grunt.loadNpmTasks "grunt-contrib-clean"

	grunt.initConfig
		pkg: grunt.file.readJSON('package.json'),
		coffee:
			dev: 
				options:
					join: false
					sourceMap: true
				files:
					'./dist/mg-srt.js': ['src/*.coffee']
		clean: ['dist']

		watch: 
			assets:
				files: ['src/*']
				tasks: ['default']

		karma:
			unit:
				configFile: "./test/karma-unit.conf.js"
				autoWatch: false
				singleRun: true

	grunt.registerTask 'default', ['clean','coffee:dev']
	grunt.registerTask 'watch', ['clean','coffee:dev','watch:assets']
	grunt.registerTask 'w', ['watch']
	grunt.registerTask "test:unit", [
		"karma:unit"
	]
