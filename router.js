
var users = require('./controllers/UserController');
var posts = require('./controllers/PostController');
var auth  = require('./controllers/AuthController');

module.exports = (app, passport)=>{

    function isLoggedIn(req, res, next) {
        if (req.isAuthenticated())
        {
            return next();
        }
        else{
            res.redirect('/signin');
        }
    }
    
    //console.log(passport);
    // app.get('', isLoggedIn, (req, res)=>{
        
    //     // if(true){
    //     //     res.redirect('/signin');
            
    //     // }
    //     res.render("index", {data: req['user'], this_css:'main'});
    // });

    app.get('/', isLoggedIn, users.lenta);
    
    app.get('/signout', isLoggedIn, function(req, res){
        req.logout();
        res.redirect('/signin');
    });

    app.get('/signin', auth.signin);

    app.get('/people', isLoggedIn, users.all);

    app.get('/profile', isLoggedIn, function(req,res){
        res.redirect('/'+req['user'].username);
    })

    app.get('/:username', isLoggedIn, users.profile);

    

    app.post('/new_message', posts.create);

    app.post('/delete_post', posts.delete);

    app.post('/subscribe', users.subscribe);

    app.post('/like', posts.like);

    app.post('/signup', passport.authenticate('local-signup', {
        successRedirect: '/profile',
        failureRedirect: '/signin',
        failureFlash: true
    }));
    
    app.post('/post-info', posts.info);

    // app.post('/signin', function(req, res, next) {
    //     passport.authenticate('local-signin', function(err, user, info) {
    //       if (err) { return next(err); }
    //       if (!user) { return res.redirect('/signin'); }
    //       req.logIn(user, function(err) {
    //         if (err) { return next(err); }
    //         return res.redirect('/' + user.username);
    //       });
    //     })(req, res, next);
    //   });
    app.post("/signin", passport.authenticate('local-signin',
    { failureRedirect: '/signin',
      failureFlash: true }), function(req, res) {
        if (req.body.rememberMe) {
          req.session.cookie.maxAge = 30 * 24 * 60 * 60 * 1000; // Cookie expires after 30 days
        } else {
          req.session.cookie.expires = false; // Cookie expires at end of session
        }
      res.redirect('/'+req['user'].username);
    });

    
};