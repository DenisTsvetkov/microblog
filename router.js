var express = require('express');
var router = express.Router();

var users = require('./controllers/UserController');
var posts = require('./controllers/PostController');

// router.get('/', (req, res)=>{
//     res.render("index", {this_css:'main'});
// });

router.get('/', (req, res)=>{
    res.render("index");
});

// router.get('/booking', users.hotels);

// router.get('/hotels', hotels.getAll);

// router.post('/info', hotels.getInfo);

module.exports = router;