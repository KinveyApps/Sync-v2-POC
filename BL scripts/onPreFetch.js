function onPreFetch(request, response, modules) {
  response.headers["x-kinvey-fetch-date"] = modules.moment();
  response.continue();
}