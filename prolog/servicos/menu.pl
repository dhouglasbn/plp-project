main :- 
    writeln("Boas vindas ao +Saude!\n"),
    writeln("Selecione uma das opções abaixo:\n"),
    writeln("1 - Criar Conta"),
    writeln("2 - Entrar em Conta"),
    writeln("3 - Sair\n"),
    read(Opcao),
    login(Opcao).

login("1") :- criar_conta("Usuarios.txt").
login("2") :- 
    writeln("\nDigite a senha:"),
    read(Senha),
    buscar_usuario_por_senha("Usuarios.txt", Senha, Usuario),
    (
        Usuario = "Conta não encontrada" ->
        writeln("\nSenha incorreta ou conta não encontrada.\n"),
        main
    ;   menu(Usuario)
    ).
login("3") :- halt.
login(_) :- 
    writeln("\nOpção inválida!\n"),
    main.

criar_conta(Arquivo) :- 
    lógica para criar uma conta
    main.

buscar_usuario_por_senha(Arquivo, Senha, Usuario) :- 
    lógica para buscar usuário por senha


menu(Usuario) :- 
    writeln("Bem-vindo! Você está logado como:", Usuario),
    % Adicione a lógica do menu aqui
    writeln("Opções do menu aqui"),
    main.

clear_screen :- write('\e[H\e[2J').

:- initialization(main).







criar_conta(Arquivo) :-
    writeln("Digite seu nome: "),
    read(Nome),
    writeln("Digite a senha: "),
    read(Senha),
    buscar_usuario_por_senha("Usuarios.txt", Senha, UsuarioEncontrado),
    (
        UsuarioEncontrado \= "Conta não encontrada" ->
        writeln("Conta já criada.\n"),
        main
    ;   writeln("Escolha seu gênero (M ou F): "),
        read(Genero),
        writeln("Digite a idade: "),
        read(IdadeStr),
        writeln("Digite o peso: "),
        read(PesoStr),
        writeln("Digite a altura: "),
        read(AlturaStr),
        writeln("Digite seu objetivo de peso: "),
        read(MetaStr),

        genero_valido(Genero),
        idade_valida(IdadeStr),
        peso_valido(PesoStr),
        altura_valida(AlturaStr),
        meta_valida(MetaStr),

        read_integer(IdadeStr, Idade),
        read_float(PesoStr, Peso),
        read_float(AlturaStr, Altura),
        read_float(MetaStr, Meta),

        Usuario = usuario(Senha, Nome, Genero, Idade, Peso, Altura, Meta, 0.0, 0.0, [], [], [], [], [], []),

        append_usuario_arquivo(Arquivo, Usuario),
        writeln("Conta criada com sucesso!\n"),
        main
    ;   writeln("Dados inválidos. Certifique-se de que todos os campos estão preenchidos corretamente.\n"),
        main
    ).

genero_valido("M") :- !.
genero_valido("F") :- !.
genero_valido(_Genero) :-
    writeln("Gênero inválido. Use 'M' para masculino ou 'F' para feminino."),
    fail.

idade_valida(IdadeStr) :-
    read_integer(IdadeStr, Idade),
    Idade > 0,
    Idade < 100, !.
idade_valida(_) :-
    writeln("Idade inválida. Deve ser um número entre 1 e 99."),
    fail.

peso_valido(PesoStr) :-
    read_float(PesoStr, Peso),
    Peso > 0, !.
peso_valido(_) :-
    writeln("Peso inválido. Deve ser um número positivo."),
    fail.

altura_valida(AlturaStr) :-
    read_float(AlturaStr, Altura),
    Altura > 0.0, !.
altura_valida(_) :-
    writeln("Altura inválida. Deve ser um número positivo."),
    fail.

meta_valida(MetaStr) :-
    read_float(MetaStr, Meta),
    Meta > 0.0, !.
meta_valida(_) :-
    writeln("Meta inválida. Deve ser um número positivo."),
    fail.

read_integer(Str, Int) :-
    catch(atom_number(Str, Int), _Error, fail).

read_float(Str, Float) :-
    catch(atom_number(Str, Float), _Error, fail).

append_usuario_arquivo(Arquivo, Usuario) :-
    abrir_arquivo_para_escrita(Arquivo, ArquivoStream),
    write(ArquivoStream, Usuario),
    write(ArquivoStream, '.\n'),
    close(ArquivoStream).

abrir_arquivo_para_escrita(Arquivo, ArquivoStream) :-
    open(Arquivo, write, ArquivoStream, [create([write])]).











mini_menu_refeicoes(Usuario, NovoUsuario) :-
    writeln("\nEscolha que tipo de refeição com que você quer interagir"),
    writeln("1 - Café"),
    writeln("2 - Almoço"),
    writeln("3 - Lanche"),
    writeln("4 - Janta"),
    writeln("5 - Voltar\n"),
    read(Opcao),

    (Opcao = "1" ->
        editar_refeicao("Café", Usuario, NovoUsuario1),
        mini_menu_refeicoes(NovoUsuario1, NovoUsuario)
    ; Opcao = "2" ->
        editar_refeicao("Almoço", Usuario, NovoUsuario2),
        mini_menu_refeicoes(NovoUsuario2, NovoUsuario)
    ; Opcao = "3" ->
        editar_refeicao("Lanche", Usuario, NovoUsuario3),
        mini_menu_refeicoes(NovoUsuario3, NovoUsuario)
    ; Opcao = "4" ->
        editar_refeicao("Janta", Usuario, NovoUsuario4),
        mini_menu_refeicoes(NovoUsuario4, NovoUsuario)
    ; Opcao = "5" ->
        NovoUsuario = Usuario
    ; 
        writeln("Opção inválida.\n"),
        mini_menu_refeicoes(Usuario, NovoUsuario)
    ).

editar_refeicao(TipoRefeicao, Usuario, NovoUsuario) :-
    writeln("Editar refeição..."), % Adicione a lógica de edição da refeição aqui
    % Atualize NovoUsuario com os dados da refeição editada
    NovoUsuario = Usuario. % Exemplo simples, a ser atualizado com a lógica real













submenu_exercicios(Usuario, NovoUsuario) :-
    writeln("\nEscolha uma opção:"),
    writeln("1 - Exercícios Anaeróbicos"),
    writeln("2 - Exercícios Aeróbicos"),
    writeln("3 - Voltar ao Menu Principal\n"),
    read(Opcao),

    (Opcao = "1" ->
        submenu_exercicios_anaerobicos(Usuario, NovoUsuario1),
        submenu_exercicios(NovoUsuario1, NovoUsuario)
    ; Opcao = "2" ->
        submenu_exercicios_aerobicos(Usuario, NovoUsuario2),
        submenu_exercicios(NovoUsuario2, NovoUsuario)
    ; Opcao = "3" ->
        NovoUsuario = Usuario
    ; 
        writeln("Opção inválida.\n"),
        submenu_exercicios(Usuario, NovoUsuario)
    ).

% Submenu para Exercícios Anaeróbicos
submenu_exercicios_anaerobicos(Usuario, NovoUsuario) :-
    writeln("\nExercícios Anaeróbicos:"),
    writeln("1 - Ver exercícios do dia"),
    writeln("2 - Ver todos os exercícios já feitos"),
    writeln("3 - Adicionar exercício realizado"),
    writeln("4 - Voltar\n"),
    read(Opcao),

    (Opcao = "1" ->
        exercicios_anaerobicos_do_dia(Usuario, ExerciciosDoDia),
        writeln(ExerciciosDoDia),
        submenu_exercicios_anaerobicos(Usuario, NovoUsuario)
    ; Opcao = "2" ->
        exercicios_anaerobicos_todos(Usuario, ExerciciosTodos),
        writeln(ExerciciosTodos),
        submenu_exercicios_anaerobicos(Usuario, NovoUsuario)
    ; Opcao = "3" ->
        adicionar_exercicio_anaerobico(Usuario, NovoUsuario1),
        submenu_exercicios_anaerobicos(NovoUsuario1, NovoUsuario)
    ; Opcao = "4" ->
        submenu_exercicios(Usuario, NovoUsuario)
    ; 
        writeln("Opção inválida.\n"),
        submenu_exercicios_anaerobicos(Usuario, NovoUsuario)
    ).

% Submenu para Exercícios Aeróbicos
submenu_exercicios_aerobicos(Usuario, NovoUsuario) :-
    writeln("\nExercícios Aeróbicos:"),
    writeln("1 - Ver exercícios do dia"),
    writeln("2 - Ver todos os exercícios já feitos"),
    writeln("3 - Adicionar exercício realizado"),
    writeln("4 - Voltar\n"),
    read(Opcao),

    (Opcao = "1" ->
        exercicios_aerobicos_do_dia(Usuario, ExerciciosDoDia),
        writeln(ExerciciosDoDia),
        submenu_exercicios_aerobicos(Usuario, NovoUsuario)
    ; Opcao = "2" ->
        exercicios_aerobicos_todos(Usuario, ExerciciosTodos),
        writeln(ExerciciosTodos),
        submenu_exercicios_aerobicos(Usuario, NovoUsuario)
    ; Opcao = "3" ->
        adicionar_exercicio_aerobico(Usuario, NovoUsuario1),
        submenu_exercicios_aerobicos(NovoUsuario1, NovoUsuario)
    ; Opcao = "4" ->
        submenu_exercicios(Usuario, NovoUsuario)
    ; 
        writeln("Opção inválida."),
        submenu_exercicios_aerobicos(Usuario, NovoUsuario)
    ).

% Funções fictícias de exemplo para exercícios
exercicios_anaerobicos_do_dia(Usuario, ["Exercício anaeróbico do dia"]).
exercicios_anaerobicos_todos(Usuario, ["Exercício anaeróbico 1", "Exercício anaeróbico 2"]).
adicionar_exercicio_anaerobico(Usuario, NovoUsuario) :- 
    writeln("Adicionar exercício anaeróbico..."), % Lógica para adicionar exercício anaeróbico aqui
    % Atualize NovoUsuario com os exercícios adicionados
    NovoUsuario = Usuario. % Exemplo simples, a ser atualizado com a lógica real

exercicios_aerobicos_do_dia(Usuario, ["Exercício aeróbico do dia"]).
exercicios_aerobicos_todos(Usuario, ["Exercício aeróbico 1", "Exercício aeróbico 2"]).
adicionar_exercicio_aerobico(Usuario, NovoUsuario) :- 
    writeln("Adicionar exercício aeróbico..."), % Lógica para adicionar exercício aeróbico aqui
    % Atualize NovoUsuario com os exercícios adicionados
    NovoUsuario = Usuario. % Exemplo simples, a ser atualizado com a lógica real
