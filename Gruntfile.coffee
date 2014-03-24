module.exports = (grunt) ->
  require('load-grunt-tasks')(grunt)

  grunt.initConfig {
    browserify: {
      bundle: {
        files: {
          'public/bundle.js': ['src/*.coffee']
        },
        options: {
          transform: ['coffeeify']
        }
      }
    },
    less: {
      all: {
        files: {
          'public/game.css': ['app/less/game.less']
        }
      }
    }
    copy: {
      html: {
        files: [
          {expand: true, cwd: 'app/', src: '**/*.html', dest: 'public/'}
        ]
      }
    }
    watch: {
      scripts: {
        files: ['src/**'],
        tasks: 'browserify'
      },
      less: {
        files: ['app/less/**'],
        tasks: 'less'
      },
      html: {
        files: ['app/**/*.html'],
        tasks: 'copy'
      }
    }
  }

  grunt.registerTask 'default', [ 'browserify', 'less', 'copy', 'watch' ]
