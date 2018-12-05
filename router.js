var express = require('express');
var router = express.Router();

var users = require('./controllers/UserController');
var hotels = require('./controllers/HotelController');

router.get('/', (req, res)=>{
    res.render("index", {this_css:'main'});
});

router.get('/booking', users.hotels);

router.get('/hotels', hotels.getAll);

router.post('/info', hotels.getInfo);

module.exports = router;