module Haskell.Services.WritePeopleToFile where

import System.IO
import Models.People
import Util.PeopleToString

writePeopleToFile :: FilePath -> [People] -> IO ()
writePeopleToFile filePath peopleList = do
    let stringPeople = peopleToString peopleList
    myFile <- openFile filePath WriteMode
    hPutStr myFile stringPeople
    hFlush myFile