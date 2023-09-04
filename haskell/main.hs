import Services.WriteFile
-- import Services.ReadFile as ReadFile
import System.IO

main :: IO ()
main = do
    -- Escrever texto em um arquivo
    let novoTexto = "Este é um novo texto que será escrito no arquivo."
    --WriteFile.savePeopleJson "database.json" novoTexto
    outh <- openFile "database.txt" WriteMode
    hPutStrLn outh novoTexto
    --writeFile "database.txt" novoTexto
    putStrLn "Texto escrito com sucesso!"
