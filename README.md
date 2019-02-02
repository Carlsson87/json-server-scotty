# Scotty JSON Server

### API

1. Save a document by sending a `POST` to `/`. You will receive a response with status `201` and the body will be a string, which is the key to the document.
2. Get an existing document by sending a `GET` to `/{key}`. You will receive a response containing your json document.
3. Update an existing document by sending a `PUT` to `/{key}`. You will receive an empty response with status `204` if the update was successful.
