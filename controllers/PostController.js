const db = require('../config/Db').db;

async function create(req, res){
    var user_id = req.body.id_user;
    var post_text = req.body.post_text;
    
    if(!user_id || !post_text) {
        res.status(418).send('wrong data')
        return;
    }

    const new_post = await db.func('create_post', [user_id, post_text]);

    if(req.body.poll_option != null){
        if(typeof req.body.poll_option == 'object'){
            if(req.body.poll_option.length != 0){
                db.func('create_poll', [new_post[0].create_post, JSON.stringify(req.body.poll_option), req.body.poll_title]);
            }
        }
        else if(typeof req.body.poll_option == 'string'){
            var poll = [];
            poll.push(req.body.poll_option);
            db.func('create_poll', [new_post[0].create_post, JSON.stringify(poll), req.body.poll_title]);
        }
    }
    
    res.redirect('back');
}

exports.remove = (req, res) => {
    var post_id = req.body.post_id;

    if(!post_id) {
        res.status(418).send('wrong data')
        return;
    }

    db.func('delete_post', post_id)
    .then(() => {
        res.redirect('back');
    })
    .catch(error => {
        console.log('Error create post in ' + post_id + ':\n' + error);
        res.send('501');
    });
}

async function info(req, res){
    const postComments = await db.func('get_post_comments', req.body.post_id);
    let postInfo = {};
    postInfo.postComments = postComments;
    postInfo.loginedUser = req['user'].id;
    postInfo.postId = parseInt(req.body.post_id);
    res.status(200).send(postInfo);
}

exports.create = create;
exports.info = info;