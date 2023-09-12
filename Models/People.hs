module Haskell.Models.People where

data People = People { 
 identifier :: Int,
 name :: String,
 gender :: String,
 age :: Int,
 height :: Float,
 weight :: Float
} deriving (Show)

-- V2.0

-- data Usuario = Usuario {
--   senha :: String,
--   perfil :: UsuarioPerfil,
--   exercicios :: [Exercicios],
--   refeiçoes :: [refeiçoes]
--}

-- data UsuarioPerfil = UsuarioPerfil {
--    nome :: String,
--    genero :: String,
--    idade :: Int,
--    peso :: Double,
--    altura :: Double,
--    meta :: Double
--}
