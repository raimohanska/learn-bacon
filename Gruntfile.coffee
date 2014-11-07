module.exports = (grunt) ->
  require('load-grunt-tasks')(grunt)

  grunt.initConfig {
    browserify: {
      bundle: {
        files: {
          'output/bundle.js': ['app/script/*.coffee']
        },
        options: {
          transform: ['coffeeify']
        }
      }
    },
    less: {
      all: {
        files: {
          'output/game.css': ['app/less/game.less']
        }
      }
    }
    copy: {
      html: {
        files: [
        ]
      }
    }
    watch: {
      scripts: {
        files: ['app/script/**'],
        tasks: 'browserify'
      },
      less: {
        files: ['app/less/**'],
        tasks: 'less'
      }
    }
  }

  grunt.registerTask 'build', [ 'browserify', 'less', 'copy']
  grunt.registerTask 'default', [ 'build', 'watch' ]
