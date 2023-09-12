module Main where

import Data.Aeson
import Data.ByteString.Lazy as B
import Data.ByteString.Lazy.Char8 as BC
import System.IO.Unsafe
import System.IO
import System.Directory

data People = People { 
 identifier :: Int,
 name :: String,
 age :: Int,
 height :: Float,
 weight :: Float
} deriving (Show, Generic)

instance FromJSON People
instance ToJSON People

getPeopleByID :: Int-> [People] -> People
getPeopleByID _ [] = People (-1) ""
getPeopleByID identifierS (x:xs)
 | (identifier x) == identifierS = x
 | otherwise = getPeopleByID identifierS xs

removePeopleByID :: Int -> [People] -> [People]
removePeopleByID _ [] = []
removePeopleByID identifierS (x:xs)
 | (identifier x) == identifierS = xs
 | otherwise = [x] ++ (removePeopleByID identifierS xs)

getPeopleJSON :: String -> [People]
getPeopleJSON path = do
 let file = unsafePerformIO( B.readFile path )
 let decodedFile = decode file :: Maybe [People]
 case decodedFile of
  Nothing -> []
  Just out -> out

savePeopleJSON :: String -> Int -> String -> Int -> Float -> Float -> IO()
savePeopleJSON jsonFilePath identifier name age height weight = do
    let p = People identifier name age height weight
    let peopleList = (getPeopleJSON jsonFilePath) ++ [p]

    B.writeFile "database.json" $ encode peopleList
    removeFile jsonFilePath
    renameFile "database.json" jsonFilePath

editPeopleNameJSON :: String -> Int -> String -> Int -> Float -> Float -> IO()
editPeopleNameJSON jsonFilePath identifier name age height weight = do
    let peopleList = getPeopleJSON jsonFilePath 
    let p = People identifier name age height weight
    let newPeopleList = (removePeopleByID identifier peopleList) ++ [p]

    B.writeFile "database.json" $ encode peopleList
    removeFile jsonFilePath
    renameFile "database.json" jsonFilePath

removePeopleJSON :: String -> Int -> IO()
removePeopleJSON jsonFilePath identifier = do
    let peopleList = getPeopleJSON jsonFilePath
    let newPeopleList = removePeopleByID identifier peopleList

    B.writeFile "database.json" $ encode peopleList
    removeFile jsonFilePath
    renameFile "database.json" jsonFilePath



main :: IO ()
main = putStrLn "Hello, Haskell!"

-- import Services.WriteFile
-- -- import Services.ReadFile as ReadFile
-- import System.IO

-- main :: IO()
-- main = do
--     -- Escrever texto em um arquivo
--     let novoTexto = "Este é um novo texto que será escrito no arquivo."
--     --WriteFile.savePeopleJson "database.json" novoTexto
--     outh <- openFile "database.txt" WriteMode
--     hPutStrLn outh novoTexto
--     --writeFile "database.txt" novoTexto
--     putStrLn "Texto escrito com sucesso!"
