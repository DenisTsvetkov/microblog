var gulp = require('gulp');
var browserSync = require('browser-sync');
var sass = require('gulp-sass');
var notify = require( 'gulp-notify' );
var nodemon = require('gulp-nodemon');

gulp.task('start', function (done) {
  nodemon({
    script: 'app.js'
  , ext: 'js hbs'
  , env: { 'NODE_ENV': 'development' }
  , done: done
  })
})

// Static Server + watching scss/html files
gulp.task('serve', ['sass-watch', 'start']);


// Compile sass into CSS & auto-inject into browsers
gulp.task('sass-watch', function() {
  return gulp.watch(["public/scss/*.scss"], function() {
    gulp.start('sass')
  })
});

// Compile sass into CSS & auto-inject into browsers
gulp.task('sass', function() {
    return gulp.src("public/scss/*.scss")
        .pipe( sass().on( 'error', notify.onError(
            {
            message: "<%= error.message %>",
            title  : "Sass Error!"
            } ) )
        )
        .pipe(gulp.dest("public/css"))
});

gulp.task('default', ['serve']);