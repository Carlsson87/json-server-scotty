{-# LANGUAGE OverloadedStrings #-}

module JSONStore (fetch, create, update) where

import Data.Text.Lazy.IO as LTIO
import Data.Text.Lazy

import Data.UUID
import Data.UUID.V4

import System.Directory (doesFileExist)


fetch :: String -> IO (Maybe Text)
fetch path = do
    exist <- doesFileExist (filepath path)
    if exist
        then
            fmap Just (LTIO.readFile (filepath path))
        else
            return Nothing


create :: Text -> IO String
create content = do
    filename <- fmap toString nextRandom
    LTIO.writeFile (filepath filename) content
    return $ filename


update :: String -> Text -> IO Bool
update key content = do
    exist <- doesFileExist (filepath key) 
    if exist
        then do
            LTIO.writeFile (filepath key) content
            return True
        else
            return False


filepath :: String -> String
filepath filename =
    mconcat ["data/", filename, ".json"]
