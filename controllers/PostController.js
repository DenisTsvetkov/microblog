const db = require('../config/Db').db;



exports.create = (req, res) => {
    console.log(req.body);
    var user_id = req.body.id_user;
    var post_text = req.body.post_text;

    if(!user_id || !post_text) {
        res.status(418).send('wrong data')
        return;
    }

    db.func('create_post', [user_id, post_text])
    .then(data => {
        var post_id = data[0];
        res.redirect('back');
    })
    .catch(error => {
        console.log('Error create post in ' + post_id + ':\n' + error);
        res.send('501');
    });
}

exports.delete = (req, res) => {
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

async function like(req, res){
    if(req.body.action == 'like'){
        const like = await db.func('like', [req['user'].id, req.body.post_id]);
        like[0].like = true;
        res.status(200).send(like[0]);
    }
    else if(req.body.action == 'unlike'){
        const unlike = await db.func('unlike', [req['user'].id, req.body.post_id]);
        unlike[0].unlike = true;
        res.status(200).send(unlike[0]);
    }
}

exports.like = like;

async function info(req, res){
    const postComments = await db.func('get_post_comments', req.body.post_id);
    let postInfo = {};
    postInfo.postComments = postComments;
    console.log('Комменты', postInfo);
    res.status(200).send(postInfo);
}

exports.info = info;