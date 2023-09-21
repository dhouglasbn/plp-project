module Models.Alimentos where

import System.IO (IOMode(WriteMode), openFile, hPutStr, withFile, hGetContents, hClose, IOMode(ReadMode))
import Data.List (find)
import Control.Monad

data Alimento = Alimento {
  nome_alimento :: String,
  kcal :: Float,
  proteinas :: Float,
  gorduras :: Float,
  carboidratos :: Float
} deriving (Show)

-- Função para adicionar um alimento manualmente
adicionarAlimentoManualmente :: [Alimento] -> IO [Alimento]
adicionarAlimentoManualmente listaAlimentos = do
  putStrLn "Digite o nome do alimento:"
  nome <- getLine
  putStrLn "Digite as calorias:"
  kcalStr <- getLine
  putStrLn "Digite as proteínas:"
  proteinasStr <- getLine
  putStrLn "Digite as gorduras:"
  gordurasStr <- getLine
  putStrLn "Digite os carboidratos:"
  carboidratosStr <- getLine

  let kcal = read kcalStr :: Float
  let proteinas = read proteinasStr :: Float
  let gorduras = read gordurasStr :: Float
  let carboidratos = read carboidratosStr :: Float
      
  let novoAlimento = criarAlimento nome kcal proteinas gorduras carboidratos
  return (novoAlimento : listaAlimentos)

-- Função para criar um novo alimento
criarAlimento :: String -> Float -> Float -> Float -> Float -> Alimento
criarAlimento nome kcal proteinas gorduras carboidratos = Alimento nome kcal proteinas gorduras carboidratos

-- Função para salvar uma lista de alimentos em um arquivo
salvarAlimentos :: FilePath -> [Alimento] -> IO ()
salvarAlimentos arquivo alimentos = do
  withFile arquivo WriteMode $ \handle -> do
    hPutStr handle (unlines (map show alimentos))

lerAlimentos :: FilePath -> IO [Alimento]
lerAlimentos arquivo = do
  withFile arquivo ReadMode $ \handle -> do
    conteudo <- hGetContents handle
    let linhas = lines conteudo
    let alimentos = map parseAlimento linhas
    return alimentos

parseAlimento :: String -> Alimento
parseAlimento linha = case words linha of
  [nome, kcal, proteinas, gorduras, carboidratos] ->
    Alimento nome (read kcal) (read proteinas) (read gorduras) (read carboidratos)
  _ -> error "Formato de alimento inválido."

-- Função para ler todo o conteúdo do arquivo de alimentos e retorná-lo como uma string
lerAlimentosComoString :: FilePath -> IO String
lerAlimentosComoString arquivo = do
  withFile arquivo ReadMode $ \handle -> do
    conteudo <- hGetContents handle
    return conteudo

-- Função para obter um alimento específico pelo nome
obterAlimentoPeloNome :: [Alimento] -> String -> Maybe Alimento
obterAlimentoPeloNome alimentos nomeAliment =
  find (\alimento -> nome_alimento alimento == nomeAliment) alimentos

-- Função para adicionar um alimento a uma lista de alimentos
adicionarAlimento :: Alimento -> [Alimento] -> [Alimento]
adicionarAlimento alimento listaAlimentos = alimento : listaAlimentos

-- Função para calcular o valor total de um atributo (kcal, proteins, lipids, carbohydrates) em uma lista de alimentos.
totalAtributo :: [Alimento] -> (Alimento -> Float) -> Float
totalAtributo alimentos atributo = sum (map atributo alimentos)

-- Função para calcular o valor total dos quatro atributos para todas as refeições juntas.
totalAtributosRefeicoes :: [Alimento] -> [Alimento] -> [Alimento] -> [Alimento] -> (Float, Float, Float, Float)
totalAtributosRefeicoes cafe almoco lanche janta =
  let totalKcal = totalAtributo cafe kcal + totalAtributo almoco kcal + totalAtributo lanche kcal + totalAtributo janta kcal
      totalProteins = totalAtributo cafe proteinas + totalAtributo almoco proteinas + totalAtributo lanche proteinas + totalAtributo janta proteinas
      totalLipids = totalAtributo cafe gorduras + totalAtributo almoco gorduras + totalAtributo lanche gorduras + totalAtributo janta gorduras
      totalCarbohydrates = totalAtributo cafe carboidratos + totalAtributo almoco carboidratos + totalAtributo lanche carboidratos + totalAtributo janta carboidratos
  in (totalKcal, totalProteins, totalLipids, totalCarbohydrates)

-- Função para calcular o valor nutricional total de uma refeição
calcularValorNutricionalTotal :: [Alimento] -> (Float, Float, Float, Float)
calcularValorNutricionalTotal alimentos =
  let totalKcal = sum (map kcal alimentos)
      totalProteinas = sum (map proteinas alimentos)
      totalGorduras = sum (map gorduras alimentos)
      totalCarboidratos = sum (map carboidratos alimentos)
  in (totalKcal, totalProteinas, totalGorduras, totalCarboidratos)

