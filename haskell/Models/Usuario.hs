module Models.Usuario where

import Models.Alimentos
import Models.ExercioRegistrado


import System.IO (IOMode(WriteMode), openFile, hPutStr, withFile, hGetContents, hClose, IOMode(ReadMode))


data Usuario = Usuario {
  id :: Int,
  senha :: String,
  nome_pessoa :: String,
  genero :: String,
  idade :: Int,
  peso :: Float,
  altura :: Float,
  meta_peso :: Float,
  metaKcal :: Float,
  kcalAtual :: Float,
  exerciciosAerobicos :: [ExercicioRegistrado],
  exerciciosAnaerobicos :: [ExercicioRegistrado],
  cafe :: [Alimento],
  almoco :: [Alimento],
  lanche :: [Alimento],
  janta :: [Alimento]
} deriving (Show)

lerUsuario :: FilePath -> IO [Usuario]
lerUsuario arquivo = do
  withFile arquivo ReadMode $ \handle -> do
    conteudo <- hGetContents handle
    let linhas = lines conteudo
    let usuarios = map parseUsuario linhas
    return usuarios

atualizarUsuarioNoArquivo :: FilePath -> Usuario -> [Usuario]
atualizarUsuarioNoArquivo arquivo novoUsuario = do
  contas <- lerUsuario arquivo
  let contasAtualizadas = map (\u -> if senha u == senha novoUsuario then novoUsuario else u) contas
  contasAtualizadas
  
salvarUsuario :: FilePath -> [Usuario] -> IO ()
salvarUsuario arquivo contas = do
  withFile arquivo WriteMode $ \handle -> do
    hPutStr handle (unlines (map show contas))

-- Função para atualizar o peso do usuário
atualizarPeso :: Usuario -> IO Usuario
atualizarPeso usuario = do
  putStrLn "Digite o novo peso: "
  peso <- getLine
  let pesoValido = peso /= "" && read peso > 0
  if pesoValido
    then do
      let novoPeso = read peso
      let usuarioAtualizado = usuario { peso = novoPeso }
      putStrLn "Peso atualizado com sucesso!"
      menu usuarioAtualizado
    else do
      putStrLn "Peso inválido. Digite um valor positivo."
      menu usuario

-- Função para atualizar a meta do usuário
atualizarMeta :: Usuario -> IO Usuario
atualizarMeta usuario = do
  putStrLn "Digite o novo valor da meta: "
  novaMetaStr <- getLine
  if metaStr /= "" && read novaMetaStr > 0.0
    then do
      let novaMeta = read novaMetaStr :: Float
          usuarioAtualizado = usuario { meta_peso = novaMeta }
      putStrLn "Meta atualizada com sucesso!"
      menu usuarioAtualizado
    else do
      putStrLn "Meta inválida. Insira um valor numérico maior que 0.0."
      menu usuario

-- Função para atualizar a idade do usuário
atualizarIdade :: Usuario -> IO Usuario
atualizarIdade usuario = do
  putStrLn "Digite a nova idade: "
  idade <- getLine
  let idadeValida = idade /= "" && read idade > 0 && read idade < 100
  if idadeValida
    then do
      let novaIdade = read idade
      let usuarioAtualizado = usuario { idade = novaIdade }
      putStrLn "Idade atualizada com sucesso!"
      menu usuarioAtualizado
    else do
      putStrLn "Idade inválida. Digite um valor entre 1 e 99."
      menu usuario

-- Função para atualizar a senha do usuário (OLHAR MELHOR ESSA PARTE E COMO É FEITA A ENTRADA PELA SENHA)
atualizarSenha :: Usuario -> IO Usuario
atualizarSenha usuario = do
  putStrLn "Digite a nova senha: "
  novaSenha <- getLine
  let usuarioAtualizado = usuario { senha = novaSenha }
  putStrLn "Senha atualizada com sucesso!"
  return usuarioAtualizado

-- Função de parser para extrair a senha de uma linha do arquivo
parseUsuario :: String -> Usuario
parseUsuario linha = case words linha of
    [senha, nome] -> Usuario senha nome
    _ -> Usuario "" ""

findUsuario :: String -> [Usuario] -> Maybe Usuario
findUsuario _ [] = Nothing
findUsuario senha (u:us) = if senha == senha u
                            then Just u 
                            else findUsuario senha us