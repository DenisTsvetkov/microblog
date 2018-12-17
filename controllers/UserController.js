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

// exports.stats = (req, res) => {
//     db.func('get_user_stats', req.params.username)
//         .then(data => {
//             return data;
//         })
//         .catch(error => {

//         })
// }

// exports.profile = (req, res) => {
//     db.func('get_user_profile', req.params.username)
//         .then(data => {
//             let userProfile = {};
//             if(data[0] != undefined){
//                 userProfile.data = data[0];
//                 db.func('get_user_stats', req.params.username)
//                     .then(stats => {
//                         userProfile.stats = stats[0];
//                         userProfile.this_css="main";
//                         res.render("profile", userProfile);
//                 })
//             }
//             else{
//                 res.send('404', 'Пользователь не найден')
//             }
//         })
//         .catch(error => {
//             console.log('Get user info: ' + req.params.username + ':\n' + error);
//  		    res.send('501')
//         })
// }

// exports.stats = (req, res) => {
//     db.func('get_user_stats', req.params.username)
//         .then(data => {
//             res.render("profile", {'stats':data[0], 'this_css':'main'});
//         })
//         .catch(error => {

//         })
// }

// exports.profile = (req, res) => {
//     db.func('get_user_profile', req.params.username)
//         .then(data => {
//             if(data[0] != undefined){
                
//                 res.render("profile", {'data':data[0], 'this_css':'main'});
//                 //next();
//             }
//             else{
//                 res.send('404', 'Пользователь не найден')
//             }
//         })
//         .catch(error => {
//             console.log('Get user info: ' + req.params.username + ':\n' + error);
//  		    res.send('501')
//         })
// }
// const getUserProfileData = () => {
//     let userProfile = {};
//     db.func('get_user_profile', req.params.username)
//         .then(data => {
           
//         })
// };

// exports.userPosts = (req, res) => {
//     db.func('create_post', [user_id, post_text])
//     .then(data => {
//         var post_id = data[0];
//         res.redirect('back');
//     })
//     .catch(error => {
//         console.log('Error create post in ' + post_id + ':\n' + error);
//         res.send('501');
//     });
// }

async function profile(req, res){
    const userProfile = {};

    const data = await db.func('get_user_profile', req.params.username);
    userProfile.data = data[0];
    
    const stats = await db.func('get_user_stats', req.params.username);
    userProfile.stats = stats[0];

    const posts = await db.func('get_all_user_posts', req.params.username);
    userProfile.posts = posts;

    userProfile.this_css = 'main';

    console.log(userProfile)
    res.render('profile', userProfile);
}

exports.profile = profile;


// async function signin(req,res){
//     const userData = {};
    
//     const data = await db.func('get_user_profile', req.body.username);
//     console.log(req.body);
//     if(req.body.password == data[0].password){
//         res.send('Вы успешно вошли');
//     }
//     else{
//         res.send('Неправильно введет пароль');
//     }
//     res.send('Неправильно введет пароль');
// }

exports.signin = (req, res) => {
    var username = req.body.login;
    var password = req.body.password;

    if(!username || !password) {
        res.status(418).send('wrong data')
        return;
    }

    db.func('get_user_profile', username)
    .then((data) => {
        console.log(data);
        if(data[0].password == password){
            res.send('Вы успешно вошли');
        }
        else{
            res.send('Неправильно введет пароль');
        }
    })
    .catch(error => {
        console.log('Error auth_user in ' + post_id + ':\n' + error);
        res.send('501');
    });
}








