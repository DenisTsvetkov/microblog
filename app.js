const express    = require('express');
const bodyParser = require('body-parser');
const expressHbs = require("express-handlebars");
const passport   = require('passport');
const session    = require('express-session');
var flash = require('connect-flash');
const favicon = require('express-favicon');

const app = express();

app.use(favicon(__dirname + '/public/img/favicon.ico'));

// For Handlebars
app.engine("hbs", expressHbs(
    {
        layoutsDir: "views/layouts", 
        defaultLayout: "layout",
        extname: "hbs",
        helpers: {
            procent: function(array, index){
                const reducer = (accumulator, currentValue) => accumulator + currentValue;
                var sum = array.reduce(reducer);
                return ((array[index]*100)/sum).toFixed(2);
            },
            ifCond: function(v1, v2, options) {
                if(v1 == v2) {
                  return options.fn(this);
                }
                return options.inverse(this);
            },
            not_equals: function(v1, v2, options) {
                if(v1 != v2) {
                  return options.fn(this);
                }
                return options.inverse(this);
            },
            count_votes: function(array, index){
                return array[index];
            },
        }
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




app.listen(3000, function(){
    console.log('Express server listening on port 3000');
});