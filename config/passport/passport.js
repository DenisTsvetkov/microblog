//load bcrypt
var bCrypt = require('bcrypt-nodejs');

const db = require('../Db').db;
var LocalStrategy   = require('passport-local').Strategy;

module.exports = function(passport){
    
    passport.serializeUser(function(user, done) {
        
        done(null, {
            id: user["id"],
            username: user["username"],
            email: user["email"],
            firstname: user['firstname'],
            surname:user['surname']
         });
    });

    // used to deserialize the user
    passport.deserializeUser(function(id, done) {
        
        db.func('get_user_profile_by_id', id.id).then(function(user) {
            if(user){
                done(null, user[0]);
            }
            else{
                done(new Error(`User with the id ${id} does not exist`));
            }
        });
    });

    passport.use('local-signup', new LocalStrategy(
        {           
            usernameField : 'username',
            passwordField : 'password',
            passReqToCallback : true // allows us to pass back the entire request to the callback
        },

        function(req, username, password, done){
            var generateHash = function(password) {
                return bCrypt.hashSync(password, bCrypt.genSaltSync(8), null);
            };

            db.func('get_user_profile', username)
            .then(data=>{
                if(data[0])
                {
                    return done(null, false, {message : 'That email is already taken'} );
                }
                else
                {
                    var userPassword = generateHash(password);
                    var data =[
                        req.body.firstname,
                        req.body.surname,
                        username,
                        userPassword,
                        req.body.email
                    ];
                    db.func('create_user', data)
                    .then(function(newUser,created){
                        if(!newUser[0]){
                            return done(null,false);
                        }

                        if(newUser[0]){
                            return done(null,newUser[0]);
                        }
                    });
                }
            }).catch(error => {console.log('Произошла ошибка:' + error)});
        }
    ));

    // //LOCAL SIGNIN
    passport.use('local-signin', new LocalStrategy(
        {
            // by default, local strategy uses username and password, we will override with email
            usernameField : 'username',
            passwordField : 'password',
            passReqToCallback : true // allows us to pass back the entire request to the callback
        },

        function(req, username, password, done) {
            var isValidPassword = function(userpass,password){
                return bCrypt.compareSync(password, userpass);
            }

            db.func('get_user_profile', username).then(function (user) {
            if (!user[0]) {
                console.log('User does not exist')
                return done(null, false, { message: 'User does not exist' });
            }

            if (!isValidPassword(user[0].password,password)) {
                console.log('Incorrect password.')
                return done(null, false, { message: 'Incorrect password.' });
            }

            var userinfo = user[0];

            return done(null,userinfo);

            }).catch(function(err){
                return done(null, false, { message: 'Something went wrong with your Signin' });
                });
    }
    ));

}
