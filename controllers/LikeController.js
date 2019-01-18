const db = require('../config/Db').db;

async function create(req, res){
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

exports.create = create;