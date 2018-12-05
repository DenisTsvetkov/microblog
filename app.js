const express = require('express');
const bodyParser = require('body-parser');
const expressHbs = require("express-handlebars");
var indexRouter = require(__dirname+'/router');
const db = require(__dirname+'/config/Db').db;
const app = express();

app.engine("hbs", expressHbs(
    {
        layoutsDir: "views/layouts", 
        defaultLayout: "layout",
        extname: "hbs"
    }
))
app.set("view engine", "hbs");

app.use('/', express.static(__dirname+'/public'));

app.use(bodyParser.json());

app.use(bodyParser.urlencoded({
  extended: true
}));

app.use('/', indexRouter);

app.listen(3000, function(){
    console.log('Express server listening on port 3000');
});