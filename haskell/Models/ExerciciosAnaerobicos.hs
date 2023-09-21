module Models.ExerciciosAnaerobicos where


import System.IO (IOMode(WriteMode), openFile, hPutStr, withFile, hGetContents, hClose, IOMode(ReadMode))
import Data.List (find)
import Data.Binary
import Control.Monad

-- Estrutura de dados para exercícios anaeróbicos
data ExercicioAnaerobico = ExercicioAnaerobico
  { nomeExercicioAnaerobico :: String,
    areaMuscular :: String,
    seriesAnaerobico :: Int,
    repeticoesAnaerobico :: Int,
    pesoAnaerobico :: Float    
  }
  deriving (Show)

instance Binary ExercicioAnaerobico where
  put (ExercicioAnaerobico nome areaMuscular seriesAnaerobico repeticoesAnaerobico pesoAnaerobico) = do
    put nome
    put areaMuscular
    put seriesAnaerobico
    put repeticoesAnaerobico
    put pesoAnaerobico
  get = liftM5 ExercicioAnaerobico get get get get get

calcularPerdaCaloricaAnaerobico :: Float -> Float -> Float
calcularPerdaCaloricaAnaerobico pesoUsuario duracaoExercicio =
  4.0 * pesoUsuario * duracaoExercicio


-- Função para buscar um exercício anaeróbico por nome em um arquivo
buscarExercicioAnaerobicoPorNome :: FilePath -> String -> IO (Maybe ExercicioAnaerobico)
buscarExercicioAnaerobicoPorNome arquivo nomeExercicio = do
  handle <- openFile arquivo ReadMode
  conteudo <- hGetContents handle
  hClose handle  -- Feche o arquivo após a leitura

  let linhas = lines conteudo
  let exercicios = map parseExercicioAnaerobico linhas
  return (find (\exercicio -> nomeExercicio == nomeExercicioAnaerobico exercicio) exercicios)

-- Função para ler exercícios anaeróbicos de um arquivo
lerExerciciosAnaerobicos :: FilePath -> IO [ExercicioAnaerobico]
lerExerciciosAnaerobicos arquivo = do
  conteudo <- readFile arquivo
  let linhas = lines conteudo
  return (map parseExercicioAnaerobico linhas)

-- Função para analisar uma linha e criar um exercício anaeróbico
parseExercicioAnaerobico :: String -> ExercicioAnaerobico
parseExercicioAnaerobico linha =
  let [nome, area] = words linha
  in ExercicioAnaerobico
    { nomeExercicioAnaerobico = nome
    , areaMuscular = area
    , seriesAnaerobico = 0 
    , repeticoesAnaerobico = 0 
    , pesoAnaerobico = 0.0  
    }

-- Função para obter um exercício anaeróbico pelo nome
obterExercicioAnaerobicoPeloNome :: [ExercicioAnaerobico] -> String -> Maybe ExercicioAnaerobico
obterExercicioAnaerobicoPeloNome exercicios nomeExercicio =
  find (\exercicio -> nomeExercicioAnaerobico exercicio == nomeExercicio) exercicios

-- Função para filtrar exercícios anaeróbicos por área muscular
filtrarExerciciosPorAreaMuscular :: [ExercicioAnaerobico] -> String -> [ExercicioAnaerobico]
filtrarExerciciosPorAreaMuscular exercicios area =
  filter (\exercicio -> areaMuscular exercicio == area) exercicios


