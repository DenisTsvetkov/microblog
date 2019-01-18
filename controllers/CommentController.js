const db = require('../config/Db').db;

async function create(req, res){
    let id_post = parseInt(req.body.id_post);
    let comment_text = req.body.comment_text;
    let resultComment = {};
    const newComment = await db.func('comment', [req['user'].id, id_post, comment_text]);
    resultComment.comment = newComment[0];
    resultComment.user = req['user'];
    res.status(200).send(resultComment);
    
}

async function remove(req, res){
    let id_comment = parseInt(req.body.id_comment);
    const uncomment = await db.func('uncomment', [req['user'].id, id_comment]);
    uncomment[0].uncomment = true;
    res.status(200).send(uncomment[0]);
}

exports.create = create;
exports.remove = remove;