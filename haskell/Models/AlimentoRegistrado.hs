module Models.AlimentoRegistrado where
import Models.Alimentos

data AlimentoRegistrado = AlimentoRegistrado {
    alimento::Alimento,
    quantia::Float
}

calculaProteinas :: AlimentoRegistrado -> Float
calculaProteinas comida = proteinas (alimento comida) * quantia comida

calculaCalorias :: AlimentoRegistrado -> Float
calculaCalorias comida = kcal (alimento comida) * quantia comida

calculaCarbos :: AlimentoRegistrado -> Float
calculaCarbos comida = carboidratos (alimento comida) * quantia comida

calculaGorduras :: AlimentoRegistrado -> Float
calculaGorduras comida = gorduras (alimento comida) * quantia comida

valorTotal :: [AlimentoRegistrado] -> (Float, Float, Float, Float)
valorTotal registrados =
    let totalKcal       = sum [kcal (alimento registrado) * quantia registrado | registrado <- registrados]
        totalProteinas  = sum [proteinas (alimento registrado) * quantia registrado | registrado <- registrados]
        totalCarbos     = sum [carboidratos (alimento registrado) * quantia registrado | registrado <- registrados]
        totalGorduras   = sum [gorduras (alimento registrado) * quantia registrado | registrado <- registrados]
    in (totalKcal, totalProteinas, totalCarbos, totalGorduras)

valorDasRefeicoes :: [AlimentoRegistrado] -> [AlimentoRegistrado] -> [AlimentoRegistrado] -> [AlimentoRegistrado] -> (Float, Float, Float, Float)
valorDasRefeicoes cafe almoco lanche janta =
    valorTotal(cafe ++ almoco ++ lanche ++ janta)