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

