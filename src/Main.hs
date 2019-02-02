{-# LANGUAGE OverloadedStrings #-}

import Web.Scotty
import Data.Text.Lazy.Encoding
import Data.Text.Lazy
import JSONStore
import Network.HTTP.Types.Status


main :: IO ()
main = scotty 3000 $ do
  post "/" saveJsonDocumentHandler
  get "/:key" getJsonDocumentHandler
  put "/:key" updateJsonDocumentHandler


saveJsonDocumentHandler :: ActionM ()
saveJsonDocumentHandler = do
    -- Get the content of the request body as an utf-8 encoded Lazy.Text.
    content <- fmap decodeUtf8 body
    -- Create a JSON document with the given content, returns a key.
    key <- liftAndCatchIO (JSONStore.create content)
    -- Set the response status to 201.
    status status201
    -- Set the response body to text containing the key.
    text (pack key)


getJsonDocumentHandler :: ActionM ()
getJsonDocumentHandler = do
    -- Get the route parameter named "key".
    key <- param "key"
    -- Fetch the content of the JSON document that corresponds to the given key.
    content <- liftAndCatchIO $ JSONStore.fetch key
    -- Return the content as a string, or pass the request to the next handler (404).
    maybe next text content


updateJsonDocumentHandler :: ActionM ()
updateJsonDocumentHandler = do
    -- Get the route parameter named "key".
    key <- param "key"
    -- Get the content of the request body as an utf-8 encoded Lazy.Text.
    content <- fmap decodeUtf8 body
    -- Update the JSON document using the content of the request.
    succeeded <- liftAndCatchIO $ JSONStore.update key content
    if succeeded
        then
            -- Response with status 204.
            status status204
        else
            -- If the update failed, pass the request to the next handler (404).
            next
