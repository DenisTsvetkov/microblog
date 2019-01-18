var user = require('./controllers/UserController');
var post = require('./controllers/PostController');
var auth  = require('./controllers/AuthController');
var comment = require('./controllers/CommentController');
var like = require('./controllers/LikeController');
var vote = require('./controllers/VoteController');
var subscribe = require('./controllers/SubscribeController');

module.exports = (app, passport)=>{

    function loggedIn(req, res, next) {
        if (req['user']) {
            next();
        } else {
            res.redirect('/signin');
        }
    }
    
    app.get('/', loggedIn, user.lenta);
    
    app.get('/signout', loggedIn, auth.signout);

    app.get('/signin', auth.signin);

    app.get('/people', loggedIn, user.all);

    app.get('/subscriptions', loggedIn, subscribe.subscriptions);

    app.get('/subscribers', loggedIn, subscribe.subscribers);

    app.get('/settings', loggedIn, user.settings);

    app.get('/edit', loggedIn, user.edit);

    app.get('/profile', loggedIn, function(req,res){
        res.redirect('/'+req['user'].username);
    })

    app.get('/:username', loggedIn, user.profile);

    app.post('/new_message', post.create);

    app.post('/delete_post', post.remove);

    app.post('/subscribe', user.subscribe);

    app.post('/like', like.create);

    app.post('/vote', vote.create);

    app.post('/comment', comment.create);

    app.post('/delete_comment', comment.remove);
    
    app.post('/post-info', post.info);

    app.post('/change_password', user.changePassword);

    app.post('/change_profile', user.changeProfile);

    app.post("/signin", passport.authenticate('local-signin',
    { failureRedirect: '/signin',
      failureFlash: true }), function(req, res) {
        
        if (req.body.rememberMe == 'on') {
          req.session.cookie.maxAge = 30 * 24 * 60 * 60 * 1000; // Cookie expires after 30 days
        } else {
          req.session.cookie.expires = false; // Cookie expires at end of session
        }
      res.redirect('/'+req['user'].username);
    });

    app.post("/signup", passport.authenticate('local-signup',
    { failureRedirect: '/signin',
      failureFlash: true }), function(req, res) {  
        req.session.cookie.maxAge = 30 * 24 * 60 * 60 * 1000; // Cookie expires after 30 days
        res.redirect('/'+req['user'].username);
    });
};