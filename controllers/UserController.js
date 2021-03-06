const db = require('../config/Db').db;
var bCrypt = require('bcrypt-nodejs');

async function all(req, res){
    const result = {};

    result.loginedUser = req['user']

    const users = await db.func('all_users', req['user'].id);
    result.users = users;

    const stats = await db.func('get_user_stats', req['user'].username);
    result.loginedUserStats = stats[0];

    result.this_css = 'main';
    res.render('people', result);
}


async function profile(req, res){
    const userProfile = {};

    //const loginedUser = await db.func('get_user_profile', req['user'].username);
    userProfile.loginedUser = req['user'];

    const data = await db.func('get_user_profile', req.params.username);
    userProfile.data = data[0];

    
    
    const stats = await db.func('get_user_stats', req.params.username);
    userProfile.stats = stats[0];

    const posts = await db.func('get_all_user_posts', [req.params.username, req['user'].id]);
    userProfile.posts = posts;
    
    req['user'].username == req.params.username ? userProfile.current_profile = true : userProfile.current_profile = false;
    
    if(userProfile.current_profile == false){
        const is_subscribe = await db.func('is_subscribe', [userProfile.loginedUser.username, req.params.username]);
        userProfile.subscribe = is_subscribe[0].is_subscribe;
    }
    
    userProfile.this_css = 'main';

    if(userProfile.data == undefined){
        res.status(404).render('notfound', userProfile);
        exit();
    }
    res.render('profile', userProfile);
}

async function lenta(req, res){
    const userProfile = {};

    //const loginedUser = await db.func('get_user_profile', req['user'].username);
    userProfile.loginedUser = req['user'];

    const stats = await db.func('get_user_stats', req['user'].username);
    userProfile.loginedUserStats = stats[0];

    const allPosts = await db.func('get_all_posts', req['user'].id);
    userProfile.allPosts = allPosts;

    userProfile.this_css = 'main';
    res.render('index', userProfile);
}

async function subscribe(req, res){
    if(req.body.action == 'subscribe'){
        const subscribe = await db.func('subscribe', [req['user'].id, req.body.user_subscribe]);
        subscribe[0].subscribe = true;
        res.status(200).send(subscribe[0]);
    }
    else if(req.body.action == 'unsubscribe'){
        const unsubscribe = await db.func('unsubscribe', [req['user'].id, req.body.user_subscribe]);
        unsubscribe[0].unsubscribe = true;
        res.status(200).send(unsubscribe[0]);
    }
}

async function settings(req, res){
    let data = {};
    data.data = req['user'];
    data.current_profile = true;
    data.this_css = 'main';
    const stats = await db.func('get_user_stats', req['user'].username);
    data.stats = stats[0];
    data.loginedUser = req['user'];
    res.render('settings', data);
}

async function changePassword(req, res){
    var generateHash = function(password) {
        return bCrypt.hashSync(password, bCrypt.genSaltSync(8), null);
    };
    let pass1 = req.body.password1;
    let pass2 = req.body.password2;
    if(pass1 == pass2){
        const user = await db.func('change_password', [req['user'].id, generateHash(pass1)]);
        res.redirect('/'+req['user'].username);
    }
}

async function edit(req, res){
    let data = {
        data: req['user'],
        this_css: 'main'
    }
    const stats = await db.func('get_user_stats', req['user'].username);
    data.stats = stats[0];
    data.loginedUser = req['user'];
    data.current_profile = true;
    res.render('edit', data);
}

async function changeProfile(req, res){
    const user = db.func('change_user', [req['user'].id, req.body.firstname, req.body.surname, req.body.email]);
    res.redirect('/'+req['user'].username);
}

exports.all = all;
exports.profile = profile;
exports.lenta = lenta;
exports.subscribe = subscribe;
exports.settings = settings;
exports.changePassword = changePassword;
exports.edit = edit;
exports.changeProfile = changeProfile;









