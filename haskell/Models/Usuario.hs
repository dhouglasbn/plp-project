module Models.Usuario where

import Models.Alimentos
import Models.ExercicioRegistrado
import Models.ExerciciosAerobicos
import Models.ExerciciosAnaerobicos

import System.IO (IOMode(WriteMode), openFile, hPutStr, withFile, hGetContents, hClose, IOMode(ReadMode))
import Data.Time (UTCTime, getCurrentTime, utctDay)
import System.IO.Unsafe (unsafePerformIO)

data Usuario = Usuario {
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

-- Função de parser para extrair a senha de uma linha do arquivo
parseUsuario :: String -> Usuario
parseUsuario linha = case words linha of
    [senha, nome] -> Usuario senha nome
    _ -> Usuario "" ""
  
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
      return usuarioAtualizado
    else do
      putStrLn "Peso inválido. Digite um valor positivo."
      return usuario

-- Função para atualizar a meta do usuário
atualizarMeta :: Usuario -> IO Usuario
atualizarMeta usuario = do
  putStrLn "Digite o novo valor da meta: "
  novaMetaStr <- getLine
  if read novaMetaStr > 0.0
    then do
      let novaMeta = read novaMetaStr :: Float
          usuarioAtualizado = usuario { meta_peso = novaMeta }
      putStrLn "Meta atualizada com sucesso!"
      return usuarioAtualizado
    else do
      putStrLn "Meta inválida. Insira um valor numérico maior que 0.0."
      return usuario

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
      return usuarioAtualizado
    else do
      putStrLn "Idade inválida. Digite um valor entre 1 e 99."
      return usuario

-- Função para atualizar a senha do usuário (OLHAR MELHOR ESSA PARTE E COMO É FEITA A ENTRADA PELA SENHA)
atualizarSenha :: Usuario -> IO Usuario
atualizarSenha usuario = do
  putStrLn "Digite a nova senha: "
  novaSenha <- getLine
  let usuarioAtualizado = usuario { senha = novaSenha }
  putStrLn "Senha atualizada com sucesso!"
  return usuarioAtualizado



findUsuario :: String -> [Usuario] -> Maybe Usuario
findUsuario _ [] = Nothing
findUsuario senh (u:us) = if senh == senha u
                            then Just u 
                            else findUsuario senh us

-- Função para calcular as calorias diárias necessárias para manter o peso
caloriasManterPeso :: Usuario -> Float
caloriasManterPeso usuario
  | genero usuario == "M" = 88.362 + (13.397 * peso usuario) + (4.799 * altura usuario) - (5.677 * fromIntegral (idade usuario))
  | genero usuario == "F" = 447.593 + (9.247 * peso usuario) + (3.098 * altura usuario) - (4.330 * fromIntegral (idade usuario))
  | otherwise = 0.0

-- Função para calcular o valor total das calorias diárias para perder peso
caloriasDiariasPerderPeso :: Usuario -> Float -> Float
caloriasDiariasPerderPeso usuario metaPeso = caloriasManterPeso usuario - (500 * (peso usuario - metaPeso))

-- Função para calcular o valor total das calorias diárias para ganhar peso
caloriasDiariasGanharPeso :: Usuario -> Float -> Float
caloriasDiariasGanharPeso usuario metaPeso = caloriasManterPeso usuario + (500 * (metaPeso - peso usuario))



-- Função para obter exercícios aeróbicos do dia
exerciciosAerobicosDoDia :: Usuario -> [ExercicioRegistrado]
exerciciosAerobicosDoDia usuario = 
  let getCurrentTime >>= filter (|exercicio -> sameDay (dataHoraExercicio exercicio) dataAtual)  exerciciosAerobicos usuario


-- Função para transformar um IO UTCTime em UTCTime
transformarIOEmUTCTime :: IO UTCTime -> UTCTime
transformarIOEmUTCTime ioAction = unsafePerformIO ioAction

-- Uso da função
main :: IO ()
main = do
  let utcTime = getCurrentTime -- Suponha que esta função retorna IO UTCTime
  let resultado = transformarIOEmUTCTime utcTime
  putStrLn $ "Valor UTCTime: " ++ show resultado


-- Função para obter todos os exercícios aeróbicos feitos
exerciciosAerobicosTodos :: Usuario -> [ExercicioRegistrado]
exerciciosAerobicosTodos usuario = exerciciosAerobicos usuario

adicionarExercicioAerobico :: Usuario -> IO Usuario
adicionarExercicioAerobico usuario = do
  putStrLn "Digite o nome do exercício aeróbico:"
  nomeExercicio <- getLine
  putStrLn "Digite a duração do exercício (em horas):"
  duracaoStr <- getLine
  
  let duracao = read duracaoStr :: Float
  
  let exercicioAerobicoEncontrado = buscarExercicioAerobicoPorNome "exerciciosAerobicos.txt" nomeExercicio

  case exercicioAerobicoEncontrado of
    Just exercicioAerobico -> do
      let metExercicio = met exercicioAerobicoEncontrado
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




-- Função para obter exercícios anaeróbicos do dia
exerciciosAnaerobicosDoDia :: Usuario -> [ExercicioRegistrado]
exerciciosAnaerobicosDoDia usuario =
  let exerciciosRegistrados = exerciciosAnaerobicos usuario
      dataAtual = getCurrentTime
  in filter (\exercicio -> sameDay (dataHoraExercicio exercicio) dataAtual) exerciciosRegistrados

-- Função para obter todos os exercícios anaeróbicos feitos
exerciciosAnaerobicosTodos :: Usuario -> [ExercicioRegistrado]
exerciciosAnaerobicosTodos usuario = exerciciosAnaerobicos usuario

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
  
  let exercicioAerobicoEncontrado = buscarExercicioAnaerobicoPorNome nomeExercicio "exerciciosAnaerobicos.txt"

  case exercicioAerobicoEncontrado of
    Just exercicioAnaerobico -> do
      let metExercicio = met exercicioAerobicoEncontrado
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