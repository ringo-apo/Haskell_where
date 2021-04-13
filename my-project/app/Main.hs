{-# LANGUAGE OverloadedStrings #-}

module Main where

import Lib
import Database.MySQL.Base
import qualified System.IO.Streams as Streams
import qualified Data.Text.IO as T
import Data.Text

main :: IO ()
main = do
    print "id name comment time"
    conn <- connect
        defaultConnectInfo {ciUser = "root", ciPassword = "Password1234!", ciDatabase = "test"}
    (defs, is) <- query_ conn "SELECT * FROM memos"
    --print =<< Streams.toList is

    let f :: MySQLValue -> IO ()
        f (MySQLText text) = do
            T.putStr text
            T.putStr " "

        f (MySQLInt32 int) = do
            T.putStr (Data.Text.pack (show int))
            T.putStr " "

        f (MySQLDateTime text) = do
            T.putStr (Data.Text.pack (show text))
            T.putStrLn ""

        f _other = return ()
    mapM_ (mapM f) =<< Streams.toList is

    print "hello"
