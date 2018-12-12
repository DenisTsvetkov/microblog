var express = require('express');
var router = express.Router();

var users = require('./controllers/UserController');
var posts = require('./controllers/PostController');


router.get('/', (req, res)=>{
    res.render("index", {this_css:'main'});
});

router.get('/:username', users.profile, users.stats);

//router.get('/profile', users.profile);

router.get('/signin', (req, res)=>{
    res.render("signin", {this_css:'main', layout: false})
});



module.exports = router;