{-# LANGUAGE OverloadedStrings #-}

import Web.Scotty
import System.Directory (doesFileExist)
import Data.Text.Lazy.IO as LTIO
import Data.Text.Lazy


main :: IO ()
main = scotty 3000 $ do
  get "/:key" getJsonDocumentHandler


getJsonDocumentHandler :: ActionM ()
getJsonDocumentHandler = do
    key <- param "key"
    content <- liftAndCatchIO $ getJsonDocument $ filepath key
    maybe next text content


filepath :: String -> String
filepath filename =
    mconcat ["data/", filename, ".json"]


getJsonDocument :: String -> IO (Maybe Text)
getJsonDocument path = do
    exist <- doesFileExist path
    if exist
        then
            fmap Just (LTIO.readFile path)
        else
            return Nothing
