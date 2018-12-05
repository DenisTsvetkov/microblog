const Hotel = require('../models/Hotel');

exports.getAll = (req, res) => {
    Hotel.all(function(error, data){
        if(error){
            console.log('Произошла ошибка: ', error);
            return res.sendStatus(500);
        }
        else{
            //data.this_css = "hotels";
            console.log(data);
            res.render("hotels", {Hotel: data, this_css:"hotels"});
        }
    });
}

exports.getInfo = (req, res) => {
    let hotel_id = req.body.hotelId;
    var result = {};

    var sendResult = (result)=>{
        console.log(result);
        res.send(result);
    }

    Hotel.getServices(hotel_id, function(error, data){
        
        if(error){
            console.log('Произошла ошибка: ', error);
            return res.sendStatus(500);
        }
        else{
            result.services = data;
        }
    });

    Hotel.getEntertainments(hotel_id, function(error, data){
    
        if(error){
            console.log('Произошла ошибка: ', error);
            return res.sendStatus(500);
        }
        else{
            result.entertainments = data;
            sendResult(result);
        }
        
    });

    
}
