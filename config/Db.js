const pgp = require('pg-promise')();
const cn = {
    host: 'localhost',
    port: 5432,
    database: 'microblog',
    user: 'postgres',
    password: '' //password here
};

exports.db = pgp(cn);