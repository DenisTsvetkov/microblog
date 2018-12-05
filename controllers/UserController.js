const db = require('../config/Db').db;

exports.getAll = (req, res) => {
    User.all(function(error, data){
        if(error){
            console.log('Произошла ошибка: ', error);
            return res.sendStatus(500);
        }
        else{
            //data.this_css = "hotels";
            console.log(data);
            res.render("index", {Hotel: data, this_css:"hotels"});
        }
    });
}