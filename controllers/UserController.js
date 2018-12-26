const db = require('../config/Db').db;

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

    const loginedUser = await db.func('get_user_profile', req['user'].username);
    userProfile.loginedUser = loginedUser[0];

    const data = await db.func('get_user_profile', req.params.username);
    userProfile.data = data[0];

    
    
    const stats = await db.func('get_user_stats', req.params.username);
    userProfile.stats = stats[0];

    const posts = await db.func('get_all_user_posts', req.params.username);
    userProfile.posts = posts;
    console.log('REQ PARAMS USERNAME', req.params.username)
    req['user'].username == req.params.username ? userProfile.current_profile = true : userProfile.current_profile = false;
    
    //userProfile.loginedUser = req['user'];
    userProfile.this_css = 'main';

    console.log(userProfile)
    if(userProfile.data == undefined){
        res.render('notfound', userProfile);
        exit();
    }
    res.render('profile', userProfile);
}

async function lenta(req, res){
    const userProfile = {};

    const loginedUser = await db.func('get_user_profile', req['user'].username);
    userProfile.loginedUser = loginedUser[0];

    // const data = await db.func('get_user_profile', req['user'].username);
    // userProfile.data = data[0];
    
    const stats = await db.func('get_user_stats', req['user'].username);
    userProfile.loginedUserStats = stats[0];

    // const posts = await db.func('get_all_user_posts', req.params.username);
    // userProfile.posts = posts;

    req.params.username == req['user'].username ? userProfile.current_profile = true : userProfile.current_profile = false;
    //userProfile.loginedUser = req['user'];
    userProfile.this_css = 'main';

    console.log(userProfile)
    res.render('index', userProfile);
}

exports.profile = profile;
exports.lenta = lenta;










