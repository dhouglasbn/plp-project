module Haskell.Util.ParsePeople where

import Models.People

parsePeople :: String -> Maybe People
parsePeople line = case split '|' line of
  [idStr, name, gender, ageStr, heightStr, weightStr] ->
    Just $
      People
        { identifier = read idStr,
          name = name,
          gender = gender,
          age = read ageStr,
          height = read heightStr,
          weight = read weightStr
        }
  _ -> Nothing
  where
    split :: Char -> String -> [String]
    split _ [] = [""]
    split delimiter (x : xs)
      | x == delimiter = "" : rest
      | otherwise = (x : head rest) : tail rest
      where
        rest = split delimiter xs