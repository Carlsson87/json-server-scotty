{-# LANGUAGE OverloadedStrings #-}

import Web.Scotty
import Data.Text.Lazy.Encoding
import Data.Text.Lazy
import JSONStore


main :: IO ()
main = scotty 3000 $ do
  post "/" saveJsonDocumentHandler
  get "/:key" getJsonDocumentHandler
  put "/:key" updateJsonDocumentHandler


saveJsonDocumentHandler :: ActionM ()
saveJsonDocumentHandler = do
    content <- fmap decodeUtf8 body
    key <- liftAndCatchIO (JSONStore.create content)
    text (pack key)


getJsonDocumentHandler :: ActionM ()
getJsonDocumentHandler = do
    key <- param "key"
    content <- liftAndCatchIO $ JSONStore.fetch key
    maybe next text content


updateJsonDocumentHandler :: ActionM ()
updateJsonDocumentHandler = do
    key <- param "key"
    content <- fmap decodeUtf8 body
    succeeded <- liftAndCatchIO $ JSONStore.update key content
    if succeeded
        then
            text ""
        else
            next
