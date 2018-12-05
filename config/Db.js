const mysql = require('mysql');
const pool  = mysql.createPool({
  host            : 'localhost',
  user            : 'denis_tsvetkov',
  password        : 'batman59',
  database        : 'hotelcomplex'
});
exports.db = pool;