module.exports = (grunt) ->
  require('load-grunt-tasks')(grunt)

  grunt.initConfig {
    browserify: {
      bundle: {
        files: {
          'app/bundle.js': ['src/*.coffee']
        },
        options: {
          transform: ['coffeeify']
        }
      }
    },
    watch: {
      scripts: {
        files: ['src/**'],
        tasks: 'browserify'
      }
    }
  }

  grunt.registerTask 'default', [ 'browserify', 'watch' ]
