function onPostDelete(request, response, modules) {
  var collectionAccess = modules.collectionAccess;
  var Promises = modules.bluebird;
  var logger = modules.logger;
  var recordsDeleted = modules.utils.tempObjectStore.get('recordsDeleted');
  var collection = collectionAccess.collection(request.collectionName + '-deleted');
  var savePromises = [];
  recordsDeleted.forEach(function(recordDeleted) {
    recordDeleted.originalId = recordDeleted._id;
    delete recordDeleted._id;
    delete recordDeleted._kmd;
    savePromises.push(collection.saveAsync(modules.kinvey.entity(recordDeleted)));
  });
  Promises.all(savePromises).then(function() {
    response.continue();
  });
}
