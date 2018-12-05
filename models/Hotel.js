const db = require('../config/Db').db;

exports.all = function(callback){
    db.query('SELECT * FROM Hotel', callback);
}

exports.getServices = function(hotel_id, callback){

    db.query('SELECT name FROM Service, Service_Hotel WHERE Service_Hotel.hotel_id = ? and Service.id = Service_Hotel.service_id', hotel_id, function(err, success, fields){
        callback(undefined, success.map(element => element.name));
    });
}

exports.getEntertainments = function(hotel_id, callback){
    db.query('SELECT name FROM Entertainment, Entertainment_Hotel WHERE Entertainment_Hotel.hotel_id = ? and Entertainment.id = Entertainment_Hotel.entertainment_id', hotel_id, function(err, success, field){
        callback(undefined, success.map(element => element.name));
    });
}