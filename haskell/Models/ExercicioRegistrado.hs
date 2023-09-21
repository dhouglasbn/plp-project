module Models.ExercicioRegistrado where

import Models.ExerciciosAerobicos
import Models.ExerciciosAnaerobicos

import Data.Time.Clock

import Data.Time.Format
import Control.Monad
import Data.Time
import Data.Time.Clock.POSIX
import Data.Int

data ExercicioRegistrado = ExercicioRegistrado
  { exercicioRealizado :: Either ExercicioAnaerobico ExercicioAerobico,
    tempoGastoExercicio :: Float,
    dataHoraExercicio :: UTCTime,
    kcalGasto :: Float
  }
  deriving (Show)


-- Função auxiliar para verificar se duas datas estão no mesmo dia
sameDay :: UTCTime -> UTCTime -> Bool
sameDay date1 date2 =
  utctDay date1 == utctDay date2

calcularTotalCaloriasDia :: UTCTime -> [ExercicioRegistrado] -> Float
calcularTotalCaloriasDia dia alldayexercicios = do
  let exerciciosDoDia = filter (\exercicio -> sameDay (dataHoraExercicio exercicio) dia) alldayexercicios
  sum [kcalGasto exercicio | exercicio <- exerciciosDoDia]
