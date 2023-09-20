module Models.ExerciciosAerobicos where 

import Models.ExercicioRegistrado
import Models.Usuario

import System.IO (IOMode(WriteMode), openFile, hPutStr, withFile, hGetContents, hClose, IOMode(ReadMode))
import Data.List (find)

-- Estrutura de dados para exercícios
data ExercicioAerobico = ExercicioAerobico
  { nomeExercicio :: String,
    met :: Float
  }
  deriving (Show)

calcularPerdaCaloricaAerobico :: Float -> Float -> Float -> Float
calcularPerdaCaloricaAerobico metExercicio pesoUsuario duracaoExercicio =
  metExercicio * pesoUsuario * duracaoExercicio

-- Função para obter exercícios aeróbicos do dia
exerciciosAerobicosDoDia :: Usuario -> [ExercicioRegistrado]
exerciciosAerobicosDoDia usuario =
  let exerciciosRegistrados = exerciciosAerobicos usuario
      dataAtual = getCurrentTime
  in filter (\exercicio -> sameDay (dataHoraExercicio exercicio) dataAtual) exerciciosRegistrados

-- Função para obter todos os exercícios aeróbicos feitos
exerciciosAerobicosTodos :: Usuario -> [ExercicioRegistrado]
exerciciosAerobicosTodos usuario = return (exerciciosAerobicos usuario)

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
  let linhas = lines conteúdo
  return (map parseExercicioAerobico linhas)

-- Função para analisar uma linha e criar um exercício aeróbico
parseExercicioAerobico :: String -> ExercicioAerobico
parseExercicioAerobico linha =
  let [nome, metStr] = words linha
      met = read metStr :: Float
  in ExercicioAerobico
    { nomeExercicio = nome
    , met = met
    }
-- Função para obter um exercício aeróbico pelo nome
obterExercicioAerobicoPeloNome :: [ExercicioAerobico] -> String -> Maybe ExercicioAerobico
obterExercicioAerobicoPeloNome exercicios nomeExercicio =
  find (\exercicio -> nomeExercicioAerobico exercicio == nomeExercicio) exercicios

adicionarExercicioAerobico :: Usuario -> IO Usuario
adicionarExercicioAerobico usuario = do
  putStrLn "Digite o nome do exercício aeróbico:"
  nomeExercicio <- getLine
  putStrLn "Digite a duração do exercício (em horas):"
  duracaoStr <- getLine
  
  let duracao = read duracaoStr :: Float
  
  let exercicioAerobicoEncontrado = buscarExercicioAerobicoPorNome nomeExercicio "exerciciosAerobicos.txt"

  case exercicioAerobicoEncontrado of
    Just exercicioAerobico -> do
      let metExercicio = met exercicioAerobico
      let pesoUsuario = peso usuario

      -- Calcula o gasto calórico com base no MET, peso do usuário e duração do exercício
      let gastoCalorico = calcularPerdaCaloricaAerobico metExercicio pesoUsuario duracao

      -- Obtém a hora atual
      horaAtual <- getCurrentTime

      -- Cria o exercício registrado
      let exercicioRegistrado = ExercicioRegistrado
            { exercicioRealizado = Right exercicioAerobico
            , tempoGastoExercicio = duracao
            , dataHoraExercicio = horaAtual
            , kcalGasto = gastoCalorico
            }

      let novoUsuario = usuario { exerciciosAerobicos = exercicioRegistrado : exerciciosAerobicos usuario }

      putStrLn $ "Exercício aeróbico adicionado com sucesso! Gasto calórico: " ++ show gastoCalorico ++ " calorias."

      return novoUsuario

    Nothing -> do
      putStrLn "Exercício aeróbico não encontrado."
      return usuario


