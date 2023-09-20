data ExercicioRegistrado = ExercicioRegistrado
  { exercicioRealizado :: Either ExercicioAnaerobico ExercicioAerobico,
    tempoGastoExercicio :: Float,
    dataHoraExercicio :: UTCTime,
    kcalGasto :: Float
  }
  deriving (Show)

-- Função para calcular o gasto calórico dos exercícios realizados na data atual
calcularGastoCaloricoDataAtual :: [ExercicioRegistrado] -> Float
calcularGastoCaloricoDataAtual exerciciosRegistrados = do
  let dataAtual = getCurrentTime
  let exerciciosDoDia = filter (\exercicio -> sameDay (dataHoraExercicio exercicio) dataAtual) exerciciosRegistrados
  sum [calcularPerdaCaloricaExercicio (exercicioRealizado exercicio) (tempoGastoExercicio exercicio) | exercicio <- exerciciosDoDia]

-- Função auxiliar para verificar se duas datas estão no mesmo dia
sameDay :: UTCTime -> UTCTime -> Bool
sameDay date1 date2 =
  utctDay date1 == utctDay date2

