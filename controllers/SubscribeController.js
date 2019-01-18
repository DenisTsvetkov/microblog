const db = require('../config/Db').db;

async function subscriptions(req, res){
    const result = {};
    result.loginedUser = req['user'];

    const users = await db.func('all_subscriptions', req['user'].id);
    result.users = users;

    const stats = await db.func('get_user_stats', req['user'].username);
    result.loginedUserStats = stats[0];

    result.this_css = 'main';
    res.render('subscriptions', result);
}

async function subscribers(req, res){
    const result = {};

    result.loginedUser = req['user'];

    const users = await db.func('all_subscribers', req['user'].id);
    result.users = users;

    const stats = await db.func('get_user_stats', req['user'].username);
    result.loginedUserStats = stats[0];

    result.this_css = 'main';
    res.render('subscribers', result);
}

exports.subscriptions = subscriptions;
exports.subscribers = subscribers;









