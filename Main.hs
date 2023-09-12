module Haskell.Main where

import Models.People
import Services.ReadPeopleFromFile
import Services.WritePeopleToFile
import System.Directory
import System.IO
import System.IO.Unsafe

main :: IO ()
main = do
  let person = People 3 "Caio" "male" 20 1.70 50.0

  peopleFromDb <- readPeopleFromFile "people.txt"

  let updatedPeople = peopleFromDb ++ [person]

  writePeopleToFile "people.txt" updatedPeople

  putStrLn "Pessoa salva com sucesso!"