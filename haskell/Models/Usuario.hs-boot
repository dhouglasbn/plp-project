module Models.Usuario where

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