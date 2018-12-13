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

exports.stats = (req, res) => {
    db.func('get_user_stats', req.params.username)
        .then(data => {
            return data;
        })
        .catch(error => {

        })
}

exports.profile = (req, res) => {
    db.func('get_user_profile', req.params.username)
        .then(data => {
            let userProfile = {};
            if(data[0] != undefined){
                userProfile.data = data[0];
                db.func('get_user_stats', req.params.username)
                    .then(stats => {
                        userProfile.stats = stats[0];
                        userProfile.this_css="main";
                        res.render("profile", userProfile);
                })
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

