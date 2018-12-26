const express    = require('express');
const bodyParser = require('body-parser');
const expressHbs = require("express-handlebars");
const passport   = require('passport');
const session    = require('express-session');
var flash = require('connect-flash');

const app = express();

// For Handlebars
app.engine("hbs", expressHbs(
    {
        layoutsDir: "views/layouts", 
        defaultLayout: "layout",
        extname: "hbs"
    }
))
app.set("view engine", "hbs");


app.use('/', express.static(__dirname+'/public/'));

//For BodyParser
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({
  extended: true
}));

// For Passport
app.use(session({ secret: 'keyboard cat',resave: true, saveUninitialized:true})); // session secret
app.use(passport.initialize());
app.use(passport.session()); // persistent login sessions
app.use(flash());

//load passport strategies
require('./config/passport/passport.js')(passport);

require(__dirname+'/router')(app,passport);



// For Router
//var router = express.Router();
// var indexRouter = require(__dirname+'/router');
// app.use('/', indexRouter);



app.listen(3000, function(){
    console.log('Express server listening on port 3000');
});