module Main where

import Models.Alimentos
import Models.ExerciciosAerobicos
import Models.ExerciciosAnaerobicos
import Models.ExercicioRegistrado
import Models.Usuario


import System.IO (IOMode(WriteMode), openFile, hPutStr, withFile, hGetContents, hClose, IOMode(ReadMode))
import Data.List (find)
import System.Exit (exitSuccess)
import Control.Monad (join)
import Data.Time (UTCTime, getCurrentTime, utctDay)
import Data.List.Split

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
  user <- buscarUsuarioPorSenha "Usuarios.txt" senha
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
criarConta arquivo = do
  putStrLn "Digite seu nome: "
  nome <- getLine
  putStrLn "Digite a senha: "
  senha <- getLine

  user <- buscarUsuarioPorSenha "Usuarios.txt" senha
  case user of
    Just usuario -> do
      putStrLn "Conta já criada.\n"
      main
      
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
  let alturaValida = alturaStr /= "" && read alturaStr > 0.0
  let metaValida = metaStr /= "" && read metaStr > 0.0
  
  if generoValido && idadeValida && pesoValido && alturaValida && metaValida then
    let idade = read idadeStr :: Int
        peso = read pesoStr :: Float
        altura = read alturaStr :: Float
        meta = read metaStr :: Float
        usuario = Usuario senha nome genero idade peso altura meta 0.0 0.0 [] [] [] [] [] [] 
    in do
      appendFile arquivo (showUsuario usuario ++ "\n")
      putStrLn "Conta criada com sucesso!\n"
      main

  else do
    putStrLn "Dados inválidos. Certifique-se de que todos os campos estão preenchidos corretamente."
    main

menu :: Usuario -> IO ()
menu usuario = do
  let nome = nome_pessoa usuario
  putStr "\nBem-vindo, "
  putStrLn nome
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
      let pesoAtual = peso usuario
          meta = meta_peso usuario
          (totalKcal, totalProteins, totalLipids, totalCarbohydrates) = totalAtributosRefeicoes (cafe usuario) (almoco usuario) (lanche usuario) (janta usuario)
          metaKcal =
            if pesoAtual > meta
              then caloriasDiariasGanharPeso usuario meta
              else if pesoAtual == meta
                then caloriasManterPeso usuario
                else caloriasDiariasPerderPeso usuario meta
          metaProteins = (metaKcal * 0.25) / 4.0
          metaLipids = (metaKcal * 0.25) / 9.0
          metaCarbohydrates = (metaKcal * 0.5) / 4.0
      putStrLn $ "Total de kcal do dia/meta: " ++ show totalKcal ++ "/" ++ show metaKcal
      putStrLn $ "Total de proteins do dia/meta: " ++ show totalProteins ++ "/" ++ show metaProteins
      putStrLn $ "Total de lipids do dia/meta: " ++ show totalLipids ++ "/" ++ show metaLipids
      putStrLn $ "Total de carbohydrates do dia/meta: " ++ show totalCarbohydrates ++ "/" ++ show metaCarbohydrates
      menu usuario

    "4" -> do
      novoUsuario <- miniMenuRefeicoes usuario
      menu novoUsuario

    "5" -> do
      novoUsuario <- submenuExercicios usuario
      menu novoUsuario
    
    "6" -> do
      putStrLn "Salvando usuário..."
      salvarUsuario usuario
      putStrLn "Usuário salvo. Até logo!"
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

    "3" -> return usuario
    
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
      print =<< exerciciosAnaerobicosDoDia usuario
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
      print =<< exerciciosAerobicosDoDia usuario
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