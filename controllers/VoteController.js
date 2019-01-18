const db = require('../config/Db').db;

async function create(req, res){
    if(req.body.action == 'vote'){
        const vote = await db.func('vote', [req['user'].id, req.body.id_poll, req.body.answer]);
        res.send('true');
    }
}
exports.create = create;