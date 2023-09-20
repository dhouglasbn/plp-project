module Models.ExerciciosAnaerobicos where

import Models.ExercicioRegistrado
import Models.Usuario

import System.IO (IOMode(WriteMode), openFile, hPutStr, withFile, hGetContents, hClose, IOMode(ReadMode))
import Data.List (find)

-- Estrutura de dados para exercícios anaeróbicos
data ExercicioAnaerobico = ExercicioAnaerobico
  { nomeExercicioAnaerobico :: String,
    areaMuscular :: String,
    seriesAnaerobico :: Int,
    repeticoesAnaerobico :: Int,
    pesoAnaerobico :: Float    
  }
  deriving (Show)

calcularPerdaCaloricaAnaerobico :: Float -> Float -> Float
calcularPerdaCaloricaAnaerobico pesoUsuario duracaoExercicio =
  4.0 * pesoUsuario * duracaoExercicio

-- Função para obter exercícios anaeróbicos do dia
exerciciosAnaerobicosDoDia :: Usuario -> [ExercicioRegistrado]
exerciciosAnaerobicosDoDia usuario =
  let exerciciosRegistrados = exerciciosAnaerobicos usuario
      dataAtual = getCurrentTime
  in filter (\exercicio -> sameDay (dataHoraExercicio exercicio) dataAtual) exerciciosRegistrados

-- Função para obter todos os exercícios anaeróbicos feitos
exerciciosAnaerobicosTodos :: Usuario -> [ExercicioRegistrado]
exerciciosAnaerobicosTodos usuario = return (exerciciosAnaerobicos usuario)

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
  let linhas = lines conteúdo
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
filtrarExerciciosPorAreaMuscular exercicios areaMuscular =
  filter (\exercicio -> areaMuscular exercicio == areaMuscular) exercicios

adicionarExercicioAnaerobico :: Usuario -> IO Usuario
adicionarExercicioAnaerobico usuario = do
  putStrLn "Digite o nome do exercício anaeróbico:"
  nomeExercicio <- getLine
  putStrLn "Digite a duração do exercício (em horas):"
  duracaoStr <- getLine
  putStrLn "Digite quantas series foram feitas"
  seriesStr <- getLine
  putStrLn "Digite quantas repetiçoes por serie"
  repeticoesStr <- getLine
  
  let duracao = read duracaoStr :: Float
  let series = read seriesStr :: Int
  let repeticoes = read repeticoesStr :: Int
  
  let exercicioAerobicoEncontrado = buscarExercicioAnaerobicoPorNome "exerciciosAnaerobicos.txt" nomeExercicio

  case exercicioAerobicoEncontrado of
    Just exercicioAnaerobico -> do
      let metExercicio = met exercicioAerobico
      let pesoUsuario = peso usuario

      let gastoCalorico = calcularPerdaCaloricaAnaerobico pesoUsuario duracao

      horaAtual <- getCurrentTime

      -- Cria o exercício registrado
      let exercicioRegistrado = ExercicioRegistrado
            { exercicioRealizado = Left exercicioAnaerobico
            , tempoGastoExercicio = duracao
            , dataHoraExercicio = horaAtual
            , kcalGasto = gastoCalorico
            }

      let novoUsuario = usuario { exerciciosAnaerobicos = exercicioRegistrado : exerciciosAnaerobicos usuario }

      putStrLn $ "Exercício anaeróbico adicionado com sucesso! Gasto calórico: " ++ show gastoCalorico ++ " calorias."

      return novoUsuario

    Nothing -> do
      putStrLn "Exercício anaeróbico não encontrado."
      return usuario


-- Função para obter exercícios por área de ativação
exerciciosPorArea :: [ExercicioAnaerobico] -> String -> [ExercicioAnaerobico]
exerciciosPorArea exercicios areaDesejada =
  filter (\exercicio -> areaAtivacao exercicio == areaDesejada) exercicios