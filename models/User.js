const db = require('../config/Db').db;

exports.all = function(callback){
    db.query('SELECT * FROM Hotel', callback);
}

exports.profile = function(callback){
    db.func('get_user_profile', )
}