const db = require('../config/Db').db;

exports.hotels = (req, res) => {
    res.render("booking", {this_css:"booking"});
}