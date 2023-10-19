# Saúde +
## Introdução:
O sistema de acompanhamento de Saúde (+Saúde) é uma plataforma projetada para ajudar o usuário a monitorar seu progresso de perda ou ganho de peso de forma eficaz. Ele oferece uma variedade de recursos que permite ao usuário registrar exercícios, refeições, receber sugestões personalizadas e acompanhar seu progresso ao longo do tempo.

## Recursos Principais

### Perfil: 
Será usado como base inicial para sugestões de rotinas de exercícios e alimentar, o usuário irá responder algumas perguntas e com base nelas o usuário receberá uma base sua meta calórica diária. O usuário também pode monitorar seu consumo de calorias a partir dos exercícios realizados.O usuário irá criar uma senha para entrar no sistema para segurança de seus dados e privacidade de suas informações.
 
### Registro de Exercícios: 
O sistema permite que o usuário registre os exercícios que realizou. O usuário pode procurar por região muscular e escolher alguns exercícios que treinem a região escolhida. Cada exercício pode ter uma quantidade de séries definida pelo usuário e ele também diz o peso usado em cada série. Isso ajuda a monitorar a frequência e a variedade de exercícios ao longo do tempo.

### Registro de Refeições: 
O usuário pode registrar seus alimentos diários, especificando os alimentos consumidos e suas quantidades. O sistema oferece uma lista de alimentos comuns e suas informações nutricionais para facilitar o registro. Isso ajuda o usuário a manter um controle mais preciso de sua ingestão calórica e nutrientes.

### Sugestões de Exercícios: 
Uma função de sugestões de exercícios está disponível para o usuário. Com base nas metas de saúde do usuário e preferências pessoais, o aplicativo pode oferecer sugestões de exercícios. As sugestões podem variar para manter o usuário motivado.

### Sugestões de Refeições: 
O sistema também oferece sugestões de refeições com base nas preferências alimentares, objetivos de saúde e perfil nutricional do usuário. Ele pode fornecer opções equilibradas e saudáveis de café da manhã, almoço, jantar e lanches. Essas sugestões podem variar de acordo com as necessidades individuais, como restrições dietéticas ou preferências vegetarianas/veganas.

### Persistência dos dados: 
Caso o usuário feche o sistema, os dados não serão perdidos.

# Como executar a aplicação em Haskell
Para rodar as aplicações é necessário instalar os interpretadores `ghci` e `swipl`.

## Instalação

|Bibliotecas necessárias|Requerido para|
|-----------------------|--------------|
| List                  | Fazer Split nos arquivos do nosso banco de dados

Instale a biblioteca `list`:

```
cabal install --lib list
```

acesse o diretório haskell:

```
plp-project\haskell
```

execute o comando:

```
ghci main.hs
```

# Como executar a aplicação em prolog

acesse o diretório prolog:

```
plp-project\prolog
```

execute o comando:

```
swipl main.hs
```
