import System.IO
import System.Directory
import Control.Monad
import Data.Aeson
import qualified Data.ByteString.Lazy as B
import System.Exit (exitSuccess)

data Usuario = Usuario {
  senha :: String,
  nome :: String,
  genero :: String,
  idade :: Int,
  peso :: Double,
  altura :: Double,
  meta :: Double,
  exercicios :: [Exercicio],
  refeicoes :: [Alimento],
  -- dataInicioMeta :: Day, -- Data de início da meta
  metaCaloricaDiaria :: Float
} deriving (Show)

data Exercicio = Exercicio {
  nome :: String,
  met :: Float
} deriving (Show)
  
data Alimento = Alimento {
  nome :: String,
  kcal :: Float,
  proteinas :: Float,
  gorduras :: Float,
  carboidratos :: Float
} deriving (Show)

instance FromJSON UsuarioPerfil
instance ToJSON UsuarioPerfil

instance FromJSON Exercicio
instance ToJSON Exercicio

instance FromJSON Alimento
instance ToJSON Alimento

main :: IO ()
main = do
  putStrLn "Boas vindas!"
  putStrLn "Selecione uma das opções abaixo:\n"
  putStrLn "1 - Criar Conta"
  putStrLn "2 - Entrar em Conta"
  putStrLn "3 - Sair\n"
  opcao <- getLine
  login opcao

login :: String -> IO ()
login "1" = criarConta
login "2" = entrarConta
login "3" = exitSuccess
login _ = do
  putStrLn "Opção inválida!"
  main

menu :: Usuario -> IO ()
menu usuario = do
  putStrLn "Bem-vindo usuário!"
  putStrLn "Escolha uma opção:"
  putStrLn "1 - Registrar exercício"
  putStrLn "2 - Registrar refeição"
  putStrLn "3 - Ver perfil"
  putStrLn "4 - Ver progresso"
  putStrLn "5 - Sair"

  opcao <- getLine
  case opcao of
    "1" -> registrarExercicio usuario
    "2" -> registrarRefeicao usuario
    "3" -> verPerfil usuario
    "4" -> verProgresso usuario
    "5" -> main
    _ -> do
      putStrLn "Opção inválida!"
      menu usuario
      
-- Criar as funções para realizar as ações específicas (registrarExercicio, registrarRefeicao, etc.)

criarConta :: IO ()
criarConta = do
  putStrLn "Digite a senha: "
  senha <- getLine
  putStrLn "Digite seu nome: "
  nome <- getLine
  putStrLn "Escolha seu genero: (M ou F) "
  genero <- getLine
  putStrLn "Digite a idade: "
  idade <- readLn
  putStrLn "Digite o peso: "
  peso <- readLn
  putStrLn "Digite a altura: "
  altura <- readLn
  putStrLn "Digite sua meta de peso: "
  meta <- readLn
  let perfil = UsuarioPerfil nome genero idade peso altura meta
  let usuario = Usuario senha perfil [] []
  contas <- lerArquivo "contasDB.json"
  let contasAtualizadas = usuario : contas
  salvarArquivo "contasDB.json" contasAtualizadas
  putStrLn "Conta criada com sucesso!"
  main

entrarConta :: IO ()
entrarConta = do
  putStrLn "Digite a senha: "
  senha <- getLine
  contas <- lerArquivo "contasDB.json"
  case find (\conta -> senha == senha conta) contas of
    Just usuario -> do
      putStrLn $ "Bem-vindo, " ++ nome (perfil usuario)
      menu usuario
    Nothing -> do
      putStrLn "Senha incorreta ou conta não encontrada."
      main

--Funcoes genericas para ler os arquivos Json e salvar os dados neles-------------------
lerArquivo :: FromJSON a => FilePath -> IO [a]
lerArquivo arquivo = do
  diretorioAtual <- getCurrentDirectory
  let caminhoCompleto = combine diretorioAtual arquivo
  file <- B.readFile caminhoCompleto
  case decode file of
    Just dados -> return dados
    Nothing -> return []

salvarArquivo :: ToJSON a => FilePath -> [a] -> IO ()
salvarArquivo arquivo lista = do
  let encoded = encode lista
  B.writeFile arquivo encoded

----------------------------------------------------------------------------------------


-- Função para carregar os exercícios a partir de um arquivo de texto
carregarExercicios :: FilePath -> IO [Exercicio]
carregarExercicios arquivo = do
  conteudo <- readFile arquivo
  let linhas = lines conteudo
  return (map parseExercicio linhas)

-- Função para converter uma linha do arquivo em um exercício
parseExercicio :: String -> Exercicio
parseExercicio linha = case words linha of
  (nomeStr:metStr:kcalStr:_) ->
    Exercicio { nome = nomeStr, met = read metStr, kcalPorHora = read kcalStr }
  _ -> error "Formato de linha inválido"

-- Função para calcular o gasto calórico com base no nome do exercício, peso e tempo
calcularGastoCalorico :: [Exercicio] -> String -> Float -> Float -> Maybe Float
calcularGastoCalorico exercicios nomeExercicio peso tempo = do
  exercicio <- encontraExercicioPorNome exercicios nomeExercicio
  let metExercicio = met exercicio
  let gastoCalorico = metExercicio * peso * tempo
  return gastoCalorico

-- Função para encontrar um exercício pelo nome
encontraExercicioPorNome :: [Exercicio] -> String -> Maybe Exercicio
encontraExercicioPorNome [] _ = Nothing
encontraExercicioPorNome (exercicio:exerciciosRestantes) nomeExercicio
  | nome exercicio == nomeExercicio = Just exercicio
  | otherwise = encontraExercicioPorNome exerciciosRestantes nomeExercicio




