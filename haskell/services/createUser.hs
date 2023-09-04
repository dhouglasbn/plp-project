import System.Directory
import System.IO
import Models.People

savePeopleJSON :: String -> Int -> String -> IO()
savePeopleJSON jsonFilePath identifier name = do
 let p = People identifier name
 let peopleList = (getPeopleJSON jsonFilePath) ++ [p]

 B.writeFile "../../Temp.json" $ encode peopleList
 removeFile jsonFilePath
 renameFile "../../Temp.json" jsonFilePath