function onPreDelete(request, response, modules){
  var logger = modules.logger;
  var collectionAccess = modules.collectionAccess;
  var collection = collectionAccess.collection(request.collectionName);
  if (request.entityId) {
    collection.findOne({ _id : collection.objectID(request.entityId) }, function (err, doc) {
      if (err) {
        logger.error('Query failed: '+ err);
        response.body.debug = err;
        response.complete(500);
      } else {
        modules.utils.tempObjectStore.set('recordsDeleted', [doc]);
        response.continue();
      }
    });
  } else {
    collection.find(request.params.query, function (err, docs) {
      if (err) {
        logger.error('Query failed: '+ err);
        response.body.debug = err;
        response.complete(500);
      } else {
        modules.utils.tempObjectStore.set('recordsDeleted', docs);
        response.continue();
      }
    });
  }
}
