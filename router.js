var express = require('express');
var router = express.Router();

var users = require('./controllers/UserController');
var posts = require('./controllers/PostController');

router.get('/', (req, res)=>{
    
    // if(true){
    //     res.redirect('/signin');
        
    // }
    res.render("index", {this_css:'main'});
});



router.get('/signin', (req, res)=>{
    res.render("signin", {this_css:'main', layout: false})
});

router.get('/:username', users.profile);

//router.get('/profile', users.profile);
router.post('/new_message', posts.create);

router.post('/delete_post', posts.delete);

router.post('/signin', users.signin);



module.exports = router;