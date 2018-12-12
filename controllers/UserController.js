const db = require('../config/Db').db;

exports.getAll = (req, res) => {
    User.all(function(error, data){
        if(error){
            console.log('Произошла ошибка: ', error);
            return res.sendStatus(500);
        }
        else{
            console.log(data);
            res.render("index", {Hotel: data, this_css:"hotels"});
        }
    });
}

exports.profile = (req, res) => {
    db.func('get_user_profile', req.params.username)
        .then(data => {
            console.log(data);
            if(data[0] != undefined){
                res.render("profile", {'data':data[0], 'this_css':"main"});
            }
            else{
                res.send('404', 'Пользователь не найден')
            }
        })
        .catch(error => {
            console.log('Get user info: ' + req.params.username + ':\n' + error);
 		    res.send('501')
        })
}

exports.stats = (req, res) => {
    db.func('get_user_profile', req.params.username)
        .then(data => {
            
        })
        .catch(error => {
            console.log('Get user info: ' + req.params.username + ':\n' + error);
 		    res.send('501')
        })
}