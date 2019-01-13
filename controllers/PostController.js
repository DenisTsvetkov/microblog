const db = require('../config/Db').db;



// exports.create = (req, res) => {
//     console.log('Вот такой запросик', req.body);
//     var user_id = req.body.id_user;
//     var post_text = req.body.post_text;
//     var poll = req.body.poll_option;
//     if(!user_id || !post_text) {
//         res.status(418).send('wrong data')
//         return;
//     }

//     db.func('create_post', [user_id, post_text])
//     .then(data => {
//         let post_id = data[0].create_post;
//         console.log('ПОСТ ИД', post_id);
//         if(vote.length != 0){
//             db.func('create_poll', [post_id, JSON.stringify(poll)]);
//         }
//         res.redirect('back');
//     })
//     .catch(error => {
//         console.log('Error create post in ' + post_id + ':\n' + error);
//         res.send('501');
//     });
// }

async function create(req, res){
    console.log('Вот такой запросик', req.body);
    var user_id = req.body.id_user;
    var post_text = req.body.post_text;
    
    if(!user_id || !post_text) {
        res.status(418).send('wrong data')
        return;
    }

    const new_post = await db.func('create_post', [user_id, post_text]);

    console.log('ПОСТ ИД', new_post[0].create_post);
    if(req.body.poll_option != null){
        var poll = [];
        poll.push(req.body.poll_option);
        if(poll.length != 0){
            db.func('create_poll', [new_post[0].create_post, JSON.stringify(poll)]);
        }
    }
    
    res.redirect('back');
}

exports.create = create;


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

async function vote(req, res){
    console.log('ЗАПРОС', req.body);
    if(req.body.action == 'vote'){
        const vote = await db.func('vote', [req['user'].id, req.body.id_poll, req.body.answer]);
        res.send('true');
    }

    
}

exports.vote = vote;

async function info(req, res){
    const postComments = await db.func('get_post_comments', req.body.post_id);
    let postInfo = {};
    postInfo.postComments = postComments;
    console.log('Комменты', postInfo);
    res.status(200).send(postInfo);
}

exports.info = info;