module Haskell.Util.PeopleToString where

import Models.People
import Text.Printf (printf)

peopleToString :: [People] -> String
peopleToString peopleList = unlines $ map formatPeople peopleList
  where
    formatPeople (People id' n g a h w) =
      printf "%d|%s|%s|%d|%.2f|%.2f" id' n g a h w