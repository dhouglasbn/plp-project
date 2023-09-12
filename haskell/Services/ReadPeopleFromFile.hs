module Haskell.Services.ReadPeopleFromFile where

import System.IO
import Data.Maybe (mapMaybe)
import Models.People
import Util.ParsePeople

readPeopleFromFile :: FilePath -> IO [People]
readPeopleFromFile filePath = do
    myFile <- openFile filePath ReadMode
    fileContent <- hGetContents myFile
    hClose myFile
    let linesList = lines fileContent
    let peopleList = mapMaybe parsePeople linesList
    return peopleList