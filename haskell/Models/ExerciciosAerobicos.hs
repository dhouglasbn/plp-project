module Models.ExerciciosAerobicos where 


import System.IO (IOMode(WriteMode), openFile, hPutStr, withFile, hGetContents, hClose, IOMode(ReadMode))
import Data.List (find)

-- Estrutura de dados para exercícios
data ExercicioAerobico = ExercicioAerobico
  { nomeExercicioAerobico :: String,
    met :: Float
  }
  deriving (Show)

calcularPerdaCaloricaAerobico :: Float -> Float -> Float -> Float
calcularPerdaCaloricaAerobico metExercicio pesoUsuario duracaoExercicio =
  metExercicio * pesoUsuario * duracaoExercicio

-- Função para buscar um exercício aeróbico por nome em um arquivo
buscarExercicioAerobicoPorNome :: FilePath -> String -> IO (Maybe ExercicioAerobico)
buscarExercicioAerobicoPorNome arquivo nomeExercicio = do
  handle <- openFile arquivo ReadMode
  conteudo <- hGetContents handle
  hClose handle  -- Feche o arquivo após a leitura

  let linhas = lines conteudo
  let exercicios = map parseExercicioAerobico linhas
  return (find (\exercicio -> nomeExercicio == nomeExercicioAerobico exercicio) exercicios)

-- Função para ler exercícios aeróbicos de um arquivo
lerExerciciosAerobicos :: FilePath -> IO [ExercicioAerobico]
lerExerciciosAerobicos arquivo = do
  conteudo <- readFile arquivo
  let linhas = lines conteudo
  return (map parseExercicioAerobico linhas)

-- Função para analisar uma linha e criar um exercício aeróbico
parseExercicioAerobico :: String -> ExercicioAerobico
parseExercicioAerobico linha =
  let [nome, metStr] = words linha
      met = read metStr :: Float
  in ExercicioAerobico
    { nomeExercicioAerobico = nome
    , met = met
    }
-- Função para obter um exercício aeróbico pelo nome
obterExercicioAerobicoPeloNome :: [ExercicioAerobico] -> String -> Maybe ExercicioAerobico
obterExercicioAerobicoPeloNome exercicios nomeExerc =
  find (\exercicio -> nomeExercicioAerobico exercicio == nomeExerc) exercicios



