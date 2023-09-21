module Main where

import Models.Alimentos
import Models.ExerciciosAerobicos
import Models.ExerciciosAnaerobicos
import Models.ExercicioRegistrado
import Models.Usuario
import System.Process

import System.IO (IOMode(WriteMode), openFile, hPutStr, withFile, hGetContents, hClose, IOMode(ReadMode))
import Data.List (find)
import System.Exit (exitSuccess)
import Control.Monad (join)
import Data.Time (UTCTime, getCurrentTime, utctDay)
import Data.List.Split
import Text.Printf
import Models.AlimentoRegistrado (AlimentoRegistrado(AlimentoRegistrado), valorDasRefeicoes, valorTotal)


main :: IO ()
main = do
  clearScreen
  putStrLn "Boas vindas ao +Saude!\n"
  putStrLn "Selecione uma das opções abaixo:\n"
  putStrLn "1 - Criar Conta"
  putStrLn "2 - Entrar em Conta"
  putStrLn "3 - Sair\n"
  opcao <- getLine
  clearScreen
  login opcao

login :: String -> IO ()
login "1" = criarConta "Usuarios.txt"
login "2" = do
  putStrLn "\nDigite a senha:"
  senha <- getLine
  user <- buscarUsuarioPorSenha "Usuarios.txt" senha
  case user of
    Just usuario -> menu usuario
    Nothing -> do
      putStrLn "\nSenha incorreta ou conta não encontrada.\n"
      main
login "3" = exitSuccess
login _ = do
  putStrLn "\nOpção inválida!\n"
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
    Nothing -> do
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
      appendFile arquivo (usuarioParaLinhaTexto usuario ++ "\n")
      putStrLn "Conta criada com sucesso!\n"
      main

  else do
    putStrLn "Dados inválidos. Certifique-se de que todos os campos estão preenchidos corretamente.\n"
    main

menu :: Usuario -> IO ()
menu usuario = do
  let nome = nome_pessoa usuario
  putStrLn $ "\nBem-vindo, " ++ nome ++ "."
  putStrLn "Escolha uma opção:\n"
  putStrLn "1 - Alterar peso"
  putStrLn "2 - Alterar meta"
  putStrLn "3 - Ver progresso calorico diario"
  putStrLn "4 - Refeiçoes"
  putStrLn "5 - Exercicios"
  putStrLn "6 - Sair e salvar\n"
  
  opcao <- getLine
  clearScreen
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
          (totalKcal, totalProteins, totalLipids, totalCarbohydrates) = valorDasRefeicoes (cafe usuario) (almoco usuario) (lanche usuario) (janta usuario)
          metaKcal
            | pesoAtual < meta = caloriasDiariasGanharPeso usuario meta
            | pesoAtual == meta = caloriasManterPeso usuario
            | otherwise = caloriasDiariasPerderPeso usuario meta
          metaProteins = (metaKcal * 0.25) / 4.0
          metaLipids = (metaKcal * 0.25) / 9.0
          metaCarbohydrates = (metaKcal * 0.5) / 4.0
      printf "Total de kcal do dia/meta: %.1f/%.1f\n" totalKcal metaKcal
      printf "Total de proteins do dia/meta: %.1f/%.1f\n" totalProteins metaProteins
      printf "Total de lipids do dia/meta: %.1f/%.1f\n" totalLipids metaLipids
      printf "Total de carbohydrates do dia/meta: %.1f/%.1f\n" totalCarbohydrates metaCarbohydrates
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
      exitSuccess

    _ -> do
      putStrLn "Opção inválida!\n"
      menu usuario

-- Função principal do mini-menu
miniMenuRefeicoes :: Usuario -> IO Usuario
miniMenuRefeicoes usuario = do
  putStrLn "\nEscolha que tipo de refeição com que você quer interagir"
  putStrLn "1 - Café"
  putStrLn "2 - Almoço"
  putStrLn "3 - Lanche"
  putStrLn "4 - Janta"
  putStrLn "5 - Voltar\n"

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
      putStrLn "Opção inválida.\n"
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

      putStrLn "\nEscolha uma opção:"
      putStrLn "1 - Adicionar alimento"
      putStrLn "2 - Ver valor nutricional total"
      putStrLn "3 - Ver alimentos registrados"
      putStrLn "4 - Voltar\n"

      opcao <- getLine
      case opcao of
        "1" -> do
          putStrLn "Digite o nome do alimento que deseja adicionar:\n"
          nomeAlimento <- getLine
          alimentos <- lerAlimentos "alimentos.txt"
          let alimentoEncontrado = obterAlimentoPeloNome alimentos nomeAlimento
          case alimentoEncontrado of
            Just alimento -> do
              putStrLn "Digite quantos gramas de alimento: "
              quantiaAlimento <- getLine
              let gramas = read quantiaAlimento :: Float
              let novoAlimento = AlimentoRegistrado alimento gramas
              let novaListaRefeicao = novoAlimento : listaRefeicao
              let novoUsuario = case nome of
                    "Café" -> usuario { cafe = novaListaRefeicao }
                    "Almoço" -> usuario { almoco = novaListaRefeicao }
                    "Lanche" -> usuario { lanche = novaListaRefeicao }
                    "Janta" -> usuario { janta = novaListaRefeicao }
              putStrLn "Alimento adicionado à refeição.\n"
              editarRefeicao nome novoUsuario
            Nothing -> do
              putStrLn "Alimento não encontrado no arquivo.\n"
              editarRefeicao nome usuario

        "2" -> do
          let (totalKcal, totalProteinas, totalGorduras, totalCarboidratos) =
                valorTotal listaRefeicao
          putStrLn ("\nValor calórico total: " ++ show totalKcal ++ " kcal\n")
          putStrLn ("Proteínas totais: " ++ show totalProteinas ++ " g\n")
          putStrLn ("Gorduras totais: " ++ show totalGorduras ++ " g\n")
          putStrLn ("Carboidratos totais: " ++ show totalCarboidratos ++ " g\n")
          editarRefeicao nome usuario

        "3" -> do
          conteudoAlimentos <- lerAlimentosComoString "alimentos.txt"
          putStrLn "Alimentos disponíveis:"
          putStrLn conteudoAlimentos
          editarRefeicao nome usuario

        "4" -> miniMenuRefeicoes usuario

        _ -> do
          putStrLn "Opção inválida.\n"
          editarRefeicao nome usuario

-- Função para exibir o submenu de exercícios
submenuExercicios :: Usuario -> IO Usuario
submenuExercicios usuario = do
  putStrLn "\nEscolha uma opção:"
  putStrLn "1 - Exercícios Anaeróbicos"
  putStrLn "2 - Exercícios Aeróbicos"
  putStrLn "3 - Voltar ao Menu Principal\n"
  opcao <- getLine
  case opcao of
    "1" -> do
      submenuExerciciosAnaerobicos usuario

    "2" -> do
      submenuExerciciosAerobicos usuario
    "3" -> return usuario

    _ -> do
      putStrLn "Opção inválida.\n"
      submenuExercicios usuario

-- Submenu para Exercícios Anaeróbicos
submenuExerciciosAnaerobicos :: Usuario -> IO Usuario
submenuExerciciosAnaerobicos usuario = do
  putStrLn "\nExercícios Anaeróbicos:"
  putStrLn "1 - Ver exercicios do dia"
  putStrLn "2 - Ver todos os exercicios ja feitos"
  putStrLn "3 - Adicionar exercicio realizado"
  putStrLn "4 - Voltar\n"
  opcao <- getLine
  case opcao of
    "1" -> do
      print =<< exerciciosAnaerobicosDoDia usuario
      submenuExerciciosAnaerobicos usuario

    "2" -> do
      print (exerciciosAnaerobicosTodos usuario)
      submenuExerciciosAnaerobicos usuario

    "3" -> do
      novoUsuario <- adicionarExercicioAnaerobico usuario
      submenuExerciciosAnaerobicos novoUsuario

    "4" -> submenuExercicios usuario

    _ -> do
      putStrLn "Opção inválida.\n"
      submenuExerciciosAnaerobicos usuario

-- Submenu para Exercícios Aeróbicos
submenuExerciciosAerobicos :: Usuario -> IO Usuario
submenuExerciciosAerobicos usuario = do
  putStrLn "\nExercícios Aeróbicos:"
  putStrLn "1 - Ver exercicios do dia"
  putStrLn "2 - Ver todos os exercicios ja feitos"
  putStrLn "3 - Adicionar exercicio realizado"
  putStrLn "4 - Voltar\n"

  opcao <- getLine
  case opcao of
    "1" -> do
      print =<< exerciciosAerobicosDoDia usuario
      submenuExerciciosAerobicos usuario

    "2" -> do
      print (exerciciosAerobicosTodos usuario)
      submenuExerciciosAerobicos usuario

    "3" -> do
      novoUsuario <- adicionarExercicioAerobico usuario
      submenuExerciciosAerobicos novoUsuario

    "4" -> submenuExercicios usuario

    _ -> do
      putStrLn "Opção inválida."
      submenuExerciciosAerobicos usuario

-- Função para limpar a tela
clearScreen :: IO ()
clearScreen = do
  _ <- system "cls" -- Substitua "clear" por "cls" se estiver no Windows
  return ()