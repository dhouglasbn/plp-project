import System.IO (IOMode(WriteMode), openFile, hPutStr, withFile, hGetContents, hClose, IOMode(ReadMode))
import Data.Time (UTCTime, getCurrentTime, utctDay)
import Data.List (find)

main :: IO ()
main = do
  putStrLn "Boas vindas!"
  putStrLn "Selecione uma das opções abaixo:\n"
  putStrLn "1 - Criar Conta"
  putStrLn "2 - Entrar em Conta"
  putStrLn "3 - Sair\n"
  opcao <- getLine
  login opcao

login :: String -> IO ()
login "1" = criarConta "Usuarios.txt"
login "2" = do
  putStrLn "Digite a senha: "
  senha <- getLine
  user <- entrarConta "Usuarios.txt" senha
  case user of
    Just usuario -> menu usuario
    Nothing -> do
      putStrLn "Senha incorreta ou conta não encontrada."
      main
login "3" = exitSuccess
login _ = do
  putStrLn "Opção inválida!"
  main

criarConta :: FilePath -> IO ()
criarConta = do
  putStrLn "Digite a senha: "
  senha <- getLine
  putStrLn "Digite seu nome: "
  nome <- getLine
  putStrLn "Escolha seu genero: (M ou F) "
  genero <- getLine
  putStrLn "Digite a idade: "
  idadeStr <- getLine
  putStrLn "Digite o peso: "
  pesoStr <- getLine
  putStrLn "Digite a altura: "
  alturaStr <- getLine
  putStrLn "Digite seu objetivo de peso "
  metaStr <- getLine

  let generoValido = genero `elem` ["M", "F"]
  let idadeValida = idadeStr /= "" && read idadeStr > 0 && read idadeStr < 100
  let pesoValido = pesoStr /= "" && read pesoStr > 0
  let alturaValida = alturaStr /= "" && read alturaStr > 0
  let metaValida = metaStr /= "" && read metaStr > 0.0
  
  if generoValido && idadeValida && pesoValido && alturaValida && metaValida then
    let meta = read metaStr :: Float
        usuario = Usuario senha nome genero (read idadeStr) (read pesoStr) (read alturaStr) meta [] [] [] [] [] [] 0.0
    in do
      usuarios <- lerUsuario "Usuarios.txt"
      let usuariosAtualizados = usuario : usuarios
      salvarUsuario "Usuarios.txt" usuariosAtualizados
      putStrLn "Conta criada com sucesso!"
      main
  else do
    putStrLn "Dados inválidos. Certifique-se de que todos os campos estão preenchidos corretamente."
    main

entrarConta :: FilePath -> String -> IO (Maybe Usuario)
entrarConta "Usuarios.txt" senha = do
  usuarios <- lerUsuario "Usuarios.txt"
  let usuarioEncontrado = find (\usuario -> senha == senha usuario) usuarios
  return usuarioEncontrado

menu :: Usuario -> IO ()
menu usuario = do
  putStrLn "Bem-vindo usuário!"
  putStrLn "Escolha uma opção:"
  putStrLn "1 - Alterar peso"
  putStrLn "2 - Alterar meta"
  putStrLn "3 - Ver progresso calorico diario"
  putStrLn "4 - Refeiçoes"
  putStrLn "5 - Exercicios"
  putStrLn "6 - Sair e salvar"
  
  opcao <- getLine
  case opcao of
    "1" -> do
      novoUsuario <- atualizarPeso usuario
      menu novoUsuario
    "2" -> do
      novoUsuario <- atualizarMeta usuario
      menu novoUsuario

    "3" -> do
      let peso = peso usuario
      let meta_peso = meta_peso usuario
      let (totalKcal, totalProteins, totalLipids, totalCarbohydrates) = totalAtributosRefeicoes (cafe usuario) (almoço usuario) (lanche usuario) (janta usuario)
      let metaKcal = do 
        if peso > meta_peso
          then caloriasDiariasGanharPeso usuario meta_peso
          else if peso == meta_peso
            then caloriasManterPeso usuario
            else caloriasDiariasPerderPeso usuario meta_peso
      let metaProteins = (metaKcal * 0.25) / 4.0
      let metaLipids = (metaKcal * 0.25) / 9.0
      let metaCarbohydrates = (metaKcal * 0.5) / 4.0
      putStrLn $ "Total de kcal do dia/meta: " ++ show totalKcal ++ "/" ++ show metaKcal
      putStrLn $ "Total de proteins do dia/meta: " ++ show totalProteins ++ "/" ++ show metaProteins
      putStrLn $ "Total de lipids do dia/meta: " ++ show totalLipids ++ "/" ++ show metaLipids
      putStrLn $ "Total de carbohydrates do dia/meta: " ++ show totalCarbohydrates ++ "/" ++ show metaCarbohydrates
      menu usuario

    "4" -> do
      let novoUsuario <- miniMenuRefeicoes usuario
      menu novoUsuario

    "5" -> do
      let novoUsuario <- submenuExercicios usuario
      menu novoUsuario
    
    "6" -> do
      let contasAtualizadas = atualizarUsuarioNoArquivo "Usuarios.txt" usuario
      salvarUsuario "Usuarios.txt" contasAtualizadas
      exitSuccess
    
    _ -> do
      putStrLn "Opção inválida!"
      menu usuario

-- Função principal do mini-menu
miniMenuRefeicoes :: Usuario -> IO Usuario
miniMenuRefeicoes usuario = do
  putStrLn "Escolha que tipo de refeição com que você quer interagir"
  putStrLn "1 - Café"
  putStrLn "2 - Almoço"
  putStrLn "3 - Lanche"
  putStrLn "4 - Janta"
  putStrLn "5 - Voltar"

  opcao <- getLine

  case opcao of
    "1" -> do
      novoUsuario <- editarRefeicao "Café" usuario
      miniMenuRefeicoes novoUsuario

    "2" -> do
      novoUsuario <- editarRefeicao "Almoço" usuario
      miniMenuRefeicoes novoUsuario

    "3" -> do
      novoUsuario <- editarRefeicao "Lanche" usuario
      miniMenuRefeicoes novoUsuario

    "4" -> do
      novoUsuario <- editarRefeicao "Janta" usuario
      miniMenuRefeicoes novoUsuario

    "5" -> return usuario

    _ -> do
      putStrLn "Opção inválida."
      miniMenuRefeicoes usuario

  where
    editarRefeicao :: String -> Usuario -> IO Usuario
    editarRefeicao nome usuario = do
      putStrLn ("Editando " ++ nome)
      let listaRefeicao = case nome of
            "Café" -> cafe usuario
            "Almoço" -> almoco usuario
            "Lanche" -> lanche usuario
            "Janta" -> janta usuario

      putStrLn "Escolha uma opção:"
      putStrLn "1 - Adicionar alimento"
      putStrLn "2 - Ver valor nutricional total"
      putStrLn "3 - Ver alimentos registrados"
      putStrLn "4 - Voltar"

      opcao <- getLine
      case opcao of
        "1" -> do
          putStrLn "Digite o nome do alimento que deseja adicionar:"
          nomeAlimento <- getLine
          alimentos <- lerAlimentos "alimentos.txt"
          let alimentoEncontrado = obterAlimentoPeloNome alimentos nomeAlimento
          case alimentoEncontrado of
            Just alimento -> do
              let novaListaRefeicao = alimento : listaRefeicao
              let novoUsuario = case nome of
                    "Café" -> usuario { cafe = novaListaRefeicao }
                    "Almoço" -> usuario { almoco = novaListaRefeicao }
                    "Lanche" -> usuario { lanche = novaListaRefeicao }
                    "Janta" -> usuario { janta = novaListaRefeicao }
              putStrLn "Alimento adicionado à refeição."
              editarRefeicao nome novoUsuario
            Nothing -> do
              putStrLn "Alimento não encontrado no arquivo."
              editarRefeicao nome usuario

        "2" -> do
          let (totalKcal, totalProteinas, totalGorduras, totalCarboidratos) =
                calcularValorNutricionalTotal listaRefeicao
          putStrLn ("Valor calórico total: " ++ show totalKcal ++ " kcal")
          putStrLn ("Proteínas totais: " ++ show totalProteinas ++ " g")
          putStrLn ("Gorduras totais: " ++ show totalGorduras ++ " g")
          putStrLn ("Carboidratos totais: " ++ show totalCarboidratos ++ " g")
          editarRefeicao nome usuario

        "3" -> do
          conteudoAlimentos <- lerAlimentosComoString "alimentos.txt"
          putStrLn "Alimentos disponíveis:"
          putStrLn conteudoAlimentos
          editarRefeicao nome usuario

        "4" -> miniMenuRefeicoes usuario

        _ -> do
          putStrLn "Opção inválida."
          editarRefeicao nome usuario

-- Função para exibir o submenu de exercícios
submenuExercicios :: Usuario -> IO Usuario
submenuExercicios usuario = do
  putStrLn "Escolha uma opção:"
  putStrLn "1 - Exercícios Anaeróbicos"
  putStrLn "2 - Exercícios Aeróbicos"
  putStrLn "3 - Voltar ao Menu Principal"
  
  opcao <- getLine
  case opcao of
    "1" -> do
      submenuExerciciosAnaerobicos usuario

    "2" -> do
      submenuExerciciosAerobicos usuario

    "3" -> menu usuario
    
    _ -> do
      putStrLn "Opção inválida."
      submenuExercicios usuario

-- Submenu para Exercícios Anaeróbicos
submenuExerciciosAnaerobicos :: Usuario -> IO Usuario
submenuExerciciosAnaerobicos usuario = do
  putStrLn "Exercícios Anaeróbicos:"
  putStrLn "1 - Ver exercicios do dia"
  putStrLn "2 - Ver todos os exercicios ja feitos"
  putStrLn "3 - Adicionar exercicio realizado"
  putStrLn "4 - Voltar"
  
  opcao <- getLine
  case opcao of
    "1" -> do
      putStrLn (show (exerciciosAnaerobicosDoDia usuario))
      submenuExerciciosAnaerobicos usuario

    "2" -> do
      putStrLn (show (exerciciosAnaerobicosTodos usuario))
      submenuExerciciosAnaerobicos usuario

    "3" -> do
      novoUsuario <- adicionarExercicioAnaerobico usuario
      submenuExerciciosAnaerobicos novoUsuario

    "4" -> submenuExercicios usuario

    _ -> do
      putStrLn "Opção inválida."
      submenuExerciciosAnaerobicos usuario

-- Submenu para Exercícios Aeróbicos
submenuExerciciosAerobicos :: Usuario -> IO Usuario
submenuExerciciosAerobicos usuario = do
  putStrLn "Exercícios Aeróbicos:"
  putStrLn "1 - Ver exercicios do dia"
  putStrLn "2 - Ver todos os exercicios ja feitos"
  putStrLn "3 - Adicionar exercicio realizado"
  putStrLn "4 - Voltar"
  
  opcao <- getLine
  case opcao of
    "1" -> do
      putStrLn (show (exerciciosAerobicosDoDia usuario))
      submenuExerciciosAerobicos usuario

    "2" -> do
      putStrLn (show (exerciciosAerobicosTodos usuario))
      submenuExerciciosAerobicos usuario

    "3" -> do
      novoUsuario <- adicionarExercicioAerobico usuario
      submenuExerciciosAerobicos novoUsuario

    "4" -> submenuExercicios usuario

    _ -> do
      putStrLn "Opção inválida."
      submenuExerciciosAerobicos usuario


------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------

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
obterAlimentoPeloNome alimentos nomeAlimento =
  find (\alimento -> nomeAlimento alimento == nomeAlimento) alimentos

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

-- Estrutura de dados para exercícios anaeróbicos
data ExercicioAnaerobico = ExercicioAnaerobico
  { nomeExercicioAnaerobico :: String,
    areaMuscular :: String,
    seriesAnaerobico :: Int,
    repeticoesAnaerobico :: Int,
    pesoAnaerobico :: Float    
  }
  deriving (Show)

calcularPerdaCaloricaAnaerobico :: Float -> Float -> Float
calcularPerdaCaloricaAnaerobico pesoUsuario duracaoExercicio =
  4.0 * pesoUsuario * duracaoExercicio

-- Função para obter exercícios anaeróbicos do dia
exerciciosAnaerobicosDoDia :: Usuario -> [ExercicioRegistrado]
exerciciosAnaerobicosDoDia usuario =
  let exerciciosRegistrados = exerciciosAnaerobicos usuario
      dataAtual = getCurrentTime
  in filter (\exercicio -> sameDay (dataHoraExercicio exercicio) dataAtual) exerciciosRegistrados

-- Função para obter todos os exercícios anaeróbicos feitos
exerciciosAnaerobicosTodos :: Usuario -> [ExercicioRegistrado]
exerciciosAnaerobicosTodos usuario = return (exerciciosAnaerobicos usuario)

-- Função para buscar um exercício anaeróbico por nome em um arquivo
buscarExercicioAnaerobicoPorNome :: FilePath -> String -> IO (Maybe ExercicioAnaerobico)
buscarExercicioAnaerobicoPorNome arquivo nomeExercicio = do
  handle <- openFile arquivo ReadMode
  conteudo <- hGetContents handle
  hClose handle  -- Feche o arquivo após a leitura

  let linhas = lines conteudo
  let exercicios = map parseExercicioAnaerobico linhas
  return (find (\exercicio -> nomeExercicio == nomeExercicioAnaerobico exercicio) exercicios)

-- Função para ler exercícios anaeróbicos de um arquivo
lerExerciciosAnaerobicos :: FilePath -> IO [ExercicioAnaerobico]
lerExerciciosAnaerobicos arquivo = do
  conteudo <- readFile arquivo
  let linhas = lines conteúdo
  return (map parseExercicioAnaerobico linhas)

-- Função para analisar uma linha e criar um exercício anaeróbico
parseExercicioAnaerobico :: String -> ExercicioAnaerobico
parseExercicioAnaerobico linha =
  let [nome, area] = words linha
  in ExercicioAnaerobico
    { nomeExercicioAnaerobico = nome
    , areaMuscular = area
    , seriesAnaerobico = 0 
    , repeticoesAnaerobico = 0 
    , pesoAnaerobico = 0.0  
    }

-- Função para obter um exercício anaeróbico pelo nome
obterExercicioAnaerobicoPeloNome :: [ExercicioAnaerobico] -> String -> Maybe ExercicioAnaerobico
obterExercicioAnaerobicoPeloNome exercicios nomeExercicio =
  find (\exercicio -> nomeExercicioAnaerobico exercicio == nomeExercicio) exercicios

-- Função para filtrar exercícios anaeróbicos por área muscular
filtrarExerciciosPorAreaMuscular :: [ExercicioAnaerobico] -> String -> [ExercicioAnaerobico]
filtrarExerciciosPorAreaMuscular exercicios areaMuscular =
  filter (\exercicio -> areaMuscular exercicio == areaMuscular) exercicios

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
  
  let exercicioAerobicoEncontrado = buscarExercicioAnaerobicoPorNome "exerciciosAnaerobicos.txt" nomeExercicio

  case exercicioAerobicoEncontrado of
    Just exercicioAnaerobico -> do
      let metExercicio = met exercicioAerobico
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
      menu usuarioAtualizado
    else do
      putStrLn "Peso inválido. Digite um valor positivo."
      menu usuario

-- Função para atualizar a meta do usuário
atualizarMeta :: Usuario -> IO Usuario
atualizarMeta usuario = do
  putStrLn "Digite o novo valor da meta: "
  novaMetaStr <- getLine
  if metaStr /= "" && read novaMetaStr > 0.0
    then do
      let novaMeta = read novaMetaStr :: Float
          usuarioAtualizado = usuario { meta_peso = novaMeta }
      putStrLn "Meta atualizada com sucesso!"
      menu usuarioAtualizado
    else do
      putStrLn "Meta inválida. Insira um valor numérico maior que 0.0."
      menu usuario

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
      menu usuarioAtualizado
    else do
      putStrLn "Idade inválida. Digite um valor entre 1 e 99."
      menu usuario

-- Função para atualizar a senha do usuário (OLHAR MELHOR ESSA PARTE E COMO É FEITA A ENTRADA PELA SENHA)
atualizarSenha :: Usuario -> IO Usuario
atualizarSenha usuario = do
  putStrLn "Digite a nova senha: "
  novaSenha <- getLine
  let usuarioAtualizado = usuario { senha = novaSenha }
  putStrLn "Senha atualizada com sucesso!"
  return usuarioAtualizado




-- Função para obter exercícios por área de ativação
exerciciosPorArea :: [ExercicioAnaerobico] -> String -> [ExercicioAnaerobico]
exerciciosPorArea exercicios areaDesejada =
  filter (\exercicio -> areaAtivacao exercicio == areaDesejada) exercicios
