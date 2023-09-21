module Models.ExercicioRegistrado where

import Models.ExerciciosAerobicos
import Models.ExerciciosAnaerobicos

import Data.Time.Clock

import Data.Time.Format
import Data.Binary
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

-- Define a binary serialization instance for UTCTime
instance Binary UTCTime where
  put time = put (floor (utcTimeToPOSIXSeconds time) :: Int64)
  get = do
    posixTime <- get :: Get Int64
    return (posixSecondsToUTCTime (fromIntegral posixTime))

instance Binary ExercicioRegistrado where
  put (ExercicioRegistrado exercicio tempo dataHora kcalGasto) = do
    put exercicio
    put tempo
    put dataHora
    put kcalGasto
  get = liftM4 ExercicioRegistrado get get get get


-- Função auxiliar para verificar se duas datas estão no mesmo dia
sameDay :: UTCTime -> UTCTime -> Bool
sameDay date1 date2 =
  utctDay date1 == utctDay date2

calcularTotalCaloriasDia :: UTCTime -> [ExercicioRegistrado] -> Float
calcularTotalCaloriasDia dia alldayexercicios = do
  let exerciciosDoDia = filter (\exercicio -> sameDay (dataHoraExercicio exercicio) dia) alldayexercicios
  sum [kcalGasto exercicio | exercicio <- exerciciosDoDia]

-- Função para converter UTCTime em String
utcTimeToString :: UTCTime -> String
utcTimeToString = formatTime defaultTimeLocale "%Y-%m-%d %H:%M:%S"

stringToUTCTime :: String -> String -> Maybe UTCTime
stringToUTCTime timeFormat str =
  parseTimeM True defaultTimeLocale timeFormat str :: Maybe UTCTime

