module Models.ExercicioRegistrado where

import Data.Time (UTCTime, getCurrentTime, utctDay)

data ExercicioRegistrado = ExercicioRegistrado
  { exercicioRealizado :: Either ExercicioAnaerobico ExercicioAerobico,
    tempoGastoExercicio :: Float,
    dataHoraExercicio :: UTCTime,
    kcalGasto :: Float
  }
  deriving (Show)