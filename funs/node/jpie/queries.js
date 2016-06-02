require('dotenv').config();
var promise = require('bluebird');

var options = {
  promiseLib: promise
};

pw = process.env.DATABASE_PASSWORD
user = process.env.DATABASE_USER
database_name = process.env.DATABASE_NAME

var pgp = require('pg-promise')(options);
var connection = {
  host: 'localhost',
  user: user,
  password: pw,
  database: database_name
};

var db = pgp(connection);

module.exports = {
  getSingleNode: getSingleNode
};

function getSingleNode(req, res, next) {
  var nodeID = req.params.id;
  console.log("the node id is ");
  console.log(nodeID);

  db.one('select * from nodes where uuid = $1', nodeID)
    .then(function(data) {
      res.status(200)
         .json({
           status: 'success',
           data: data,
           message: 'Node retrieved'
         });
    })
    .catch(function(err) {
      return next(err);
    });
};
