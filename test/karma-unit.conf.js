module.exports = function(config) {
  config.set({
    files : [
      'bower_components/angular/angular.js',
      'bower_components/angular-mocks/angular-mocks.js',
      
      'src/*.coffee',
      'test/uto-srt-mock.coffee',
      'test/unit/*.coffee'
    ],
    basePath: '../',
    frameworks: ['jasmine'],
    reporters: ['progress'],
    browsers: ['Chrome'],
    autoWatch: true,
    singleRun: false,
    colors: true
  });
};
