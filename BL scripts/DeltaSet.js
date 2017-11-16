function onRequest(request, response, modules) {
  var collectionName = request.body.collection;
  var collection = modules.collectionAccess.collection(collectionName);
  var collectionDeleted = modules.collectionAccess.collection(collectionName + "-deleted");
  var Promise = modules.bluebird;
  var date = modules.moment();
  var lmt = request.body.lmt;
  var query = request.body.query;
  if (query) {
    query = {"$and": [query, {"_kmd.lmt" : {"$gt":lmt}}]};
  } else {
    query = {"_kmd.lmt" : {"$gt":lmt}};
	}
  var createsAndUpdatesPromise = collection.findAsync(query);
  var deletesPromise = collectionDeleted.findAsync({"_kmd.ect" : {"$gt":lmt}});
  var createsAndUpdatesResult = null;
  var deletesResult = null;
  createsAndUpdatesPromise.then(function(docs, err) {
    createsAndUpdatesResult = docs;
  });
  deletesPromise.then(function(docs, err) {
    deletesResult = docs;
  });
  Promise.all([createsAndUpdatesPromise, deletesPromise]).then(function(test) {
    response.body = {
      date : date,
      changed : createsAndUpdatesResult,
      deleted : deletesResult
    };
    response.complete(200);
  });
}