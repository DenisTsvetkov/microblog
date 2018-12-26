const db = require('../config/Db').db;


exports.signin = (req, res)=>{
    res.render('signin', {this_css:'main', layout: false});
}

exports.signup = function(req, res) {
    res.render('signin', {this_css:'main', layout: false});
}  
 
exports.profile = function(req, res) {
    res.render('profile');
}








