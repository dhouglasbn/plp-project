main :: IO()
main = do
  putStrLn "Boas vindas!"
  putStrLn "Selecione uma das opções abaixo:\n"
  showmenu

showmenu:: IO()
  putStrLn "1 - Criar Conta"
  putStrLn "2 - Entrar em Conta"
  putStrLn "3 - Sair\n"

  opcao <- getLine
  menus opcao

menus:: String -> IO()
menux x 
  | x == "1" = criarconta
  | x == "2" = entrarconta
  | x == "3" = exitSuccess
  | otherwise = invalidOption showMenu

data Usuario = Usuario {
    senha :: String,
    perfil :: UsuarioPerfil,
    exercicios :: [Exercicios],
    refeiçoes :: [refeiçoes]
}

data UserProfile = UserProfile {
    identificador :: Int,
    nome :: String,
    idade :: Int,
    peso :: Double,
    altura :: Double,
    meta :: Double
}


entrarconta :: String -> [Usuario] -> Usuario
entrarconta _ [] = putStrLn "Não há contas existentes"
entrarconta senha (x:xs)
  | senha == x = x
  | otherwise = entrarconta senha xs

pegarcontas :: String -> [Usuario]
pegarcontas path = do
  diretorioAtual <- getCurrentDirectory
  let caminhoCompleto = combine diretorioAtual database.json

  =file <- B.readFile caminhoCompleto
  case decode file of
    Just contas -> return contas
    Nothing -> return []


  
 let file = unsafePerformIO( B.readFile path )
 let decodedFile = decode file :: Maybe [Usuario]
 case decodedFile of
  Nothing -> []
  Just out -> out

criarconta :: String -> String -> IO()
savePeopleJSON jsonFilePath identifier name = do
 let p = People identifier name
 let peopleList = (getPeopleJSON jsonFilePath) ++ [p]

 B.writeFile "../Temp.json" $ encode peopleList
 removeFile jsonFilePath
 renameFile "../Temp.json" jsonFilePath
