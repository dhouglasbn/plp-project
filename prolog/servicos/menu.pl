main :- 
    writeln("Boas vindas ao +Saude!\n"),
    writeln("Selecione uma das opções abaixo:\n"),
    writeln("1 - Criar Conta"),
    writeln("2 - Entrar em Conta"),
    writeln("3 - Sair\n"),
    read(Opcao),
    login(Opcao).

login("1") :- criar_conta(?????).
login("2") :- 
    writeln("\nDigite a senha:"),
    read(Senha),

    ------------------------------------------------------------------------------------------------------
    buscar_usuario_por_senha("Usuarios.txt", Senha, Usuario),
    ------------------------------------------------------------------------------------------------------
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

------------------------------------------------------------------------------------------------
buscar_usuario_por_senha(Arquivo, Senha, Usuario) :- 
------------------------------------------------------------------------------------------------

criar_conta(?????) :-
    writeln("Digite seu nome: "),
    read(Nome),
    writeln("Digite a senha: "),
    read(Senha),

-----------------------------------------------------------------------------------------------
    buscar_usuario_por_senha("Usuarios.txt", Senha, UsuarioEncontrado),
-----------------------------------------------------------------------------------------------

    (
        UsuarioEncontrado \= "Conta não encontrada" ->
        writeln("Conta já criada.\n"),
        main
    ;   writeln("Escolha seu gênero (M ou F): "),
        read(Genero),
        writeln("Digite a idade: "),
        read(Idade),
        writeln("Digite o peso: "),
        read(Peso),
        writeln("Digite a altura: "),
        read(Altura),
        writeln("Digite seu objetivo de peso: "),
        read(Meta),

        Usuario = usuario(Senha, Nome, Genero, Idade, Peso, Altura, Meta, 0.0, 0.0, [], [], [], [], [], []),

        cadastra_usuario(Usuario),

        writeln("Conta criada com sucesso!\n"),
        main
    ;   writeln("Dados inválidos. Certifique-se de que todos os campos estão preenchidos corretamente.\n"),
        main
    ).

















menu(Usuario, NovoUsuario) :-
    writeln("Bem-vindo."),
    writeln("Escolha uma opção:\n"),
    writeln("1 - Configurar dados do usuario"),
    writeln("2 - Ver progresso calórico diário"),
    writeln("3 - Refeições"),
    writeln("4 - Exercícios"),
    writeln("5 - Sair e salvar\n"),
    read(Opcao),

    (Opcao = "1" ->
        mini_menu_configuracao(Usuario, NovoUsuario1),
        menu(NovoUsuario1, NovoUsuario)
    ; Opcao = "2" ->
        calcular_progresso_calorico(Usuario),
        menu(Usuario, NovoUsuario)
    ; Opcao = "3" ->
        mini_menu_refeicoes(Usuario, NovoUsuario1),
        menu(NovoUsuario1, NovoUsuario)
    ; Opcao = "4" ->
        submenu_exercicios(Usuario, NovoUsuario1),
        menu(NovoUsuario1, NovoUsuario)
    ; Opcao = "5" ->
        NovoUsuario = Usuario, 
        altera_usuario_por_id(Id, NovoUsuario),
        -----
        halt ou !?
        -----
    ; 
        writeln("Opção inválida!\n"),
        menu(Usuario, NovoUsuario)
    ).


---------------------------------------------------
calcular_progresso_calorico(Usuario) :-
---------------------------------------------------

























mini_menu_configuracao(Usuario, NovoUsuario1):-
    writeln("Escolha que tipo de dado voce deseja modificar:\n"),
    writeln("1 - Meta"),
    writeln("2 - Peso"),
    writeln("3 - Idade"),
    writeln("4 - Voltar"),
    read(Opcao),

    (Opcao = "1" ->
        atualizar_meta(Usuario, NovoUsuario1),
        mini_menu_configuracao(NovoUsuario1, NovoUsuario)
    ; Opcao = "2" ->
        atualizar_peso(Usuario, NovoUsuario1),
        mini_menu_configuracao(NovoUsuario1, NovoUsuario)
    ; Opcao = "3" ->
        atualizar_idade(Usuario, NovoUsuario1),
        mini_menu_configuracao(NovoUsuario1, NovoUsuario)
    ; Opcao = "4" ->
        menu(Usuario, NovoUsuario1)
    ; 
        writeln("Opção inválida!\n"),
        mini_menu_configuracao(Usuario, NovoUsuario1)
    ).


-------------------------------------------------------------
atualizar_peso(Usuario, NovoUsuario) :-
atualizar_meta(Usuario, NovoUsuario) :-
atualizar_idade(Usuario, NovoUsuario) :-
-------------------------------------------------------------































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
        editar_refeicao("Almoço", Usuario, NovoUsuario1),
        mini_menu_refeicoes(NovoUsuario1, NovoUsuario)
    ; Opcao = "3" ->
        editar_refeicao("Lanche", Usuario, NovoUsuario1),
        mini_menu_refeicoes(NovoUsuario1, NovoUsuario)
    ; Opcao = "4" ->
        editar_refeicao("Janta", Usuario, NovoUsuario1),
        mini_menu_refeicoes(NovoUsuario1, NovoUsuario)
    ; Opcao = "5" ->
        NovoUsuario = Usuario
    ; 
        writeln("Opção inválida.\n"),
        mini_menu_refeicoes(Usuario, NovoUsuario)
    ).


editarRefeicao(Nome, Usuario, NovoUsuario) :-
    write('Editando '), write(Nome), nl,


    --------------------------------------------------------------------------
    (Nome = 'Café' -> ListaRefeicao = cafe(Usuario)
    ; Nome = 'Almoço' -> ListaRefeicao = almoco(Usuario)
    ; Nome = 'Lanche' -> ListaRefeicao = lanche(Usuario)
    ; Nome = 'Janta' -> ListaRefeicao = janta(Usuario)
    ),
    --------------------------------------------------------------------------


    write('Escolha uma opção:'), nl,
    write('1 - Adicionar alimento'), nl,
    write('2 - Ver valor nutricional total'), nl,
    write('3 - Ver alimentos registrados'), nl,
    write('4 - Voltar'), nl,
    read(Opcao),
    (Opcao = '1' -> adicionarAlimento(Nome, Usuario, NovoUsuario)
    ; Opcao = '2' -> calcularValorNutricionalTotal(ListaRefeicao), editarRefeicao(Nome, Usuario, NovoUsuario)
    ; Opcao = '3' -> listarAlimentosDisponiveis, editarRefeicao(Nome, Usuario, NovoUsuario)
    ; Opcao = '4' -> NovoUsuario = Usuario
    ; write('Opção inválida.'), nl, editarRefeicao(Nome, Usuario, NovoUsuario)
    ).


adicionarAlimento(Nome, Usuario, NovoUsuario) :-
    writeln("Digite o nome do alimento que deseja adicionar:"),
    read(NomeAlimento),


    lerAlimentos(Alimentos),
    obterAlimentoPeloNome(Alimentos, NomeAlimento, Alimento),


    (Alimento \= 'Nenhum' ->
        writeln("Digite quantos gramas de alimento: "),
        read(QuantiaAlimento),

----------------------------------------------------------------------
        gramasFloat(QuantiaAlimento, Gramas),


        criarAlimentoRegistrado(Alimento, Gramas, AlimentoRegistrado),


        adicionarAlimentoNaRefeicao(ListaRefeicao, AlimentoRegistrado, NovaListaRefeicao),
----------------------------------------------------------------------

        (Nome = 'Café' ->
            criarUsuarioAtualizado(Usuario, cafe, NovaListaRefeicao, NovoUsuario)
        ; Nome = 'Almoço' ->
            criarUsuarioAtualizado(Usuario, almoco, NovaListaRefeicao, NovoUsuario)
        ; Nome = 'Lanche' ->
            criarUsuarioAtualizado(Usuario, lanche, NovaListaRefeicao, NovoUsuario)
        ; Nome = 'Janta' ->
            criarUsuarioAtualizado(Usuario, janta, NovaListaRefeicao, NovoUsuario)
        ),
        writeln("Alimento adicionado à refeição.\n"),
        editarRefeicao(Nome, NovoUsuario, NovoUsuario)
    ; 
        writeln("Alimento não encontrado no arquivo.\n"),
        editarRefeicao(Nome, Usuario, NovoUsuario)
    ).

calcularValorNutricionalTotal(ListaRefeicao) :-
    valorTotal(ListaRefeicao, TotalKcal, TotalProteinas, TotalGorduras, TotalCarboidratos),
    writeln("\nValor calórico total: ", TotalKcal, " kcal"),
    writeln("Proteínas totais: ", TotalProteinas, " g"),
    writeln("Gorduras totais: ", TotalGorduras, " g"),
    writeln("Carboidratos totais: ", TotalCarboidratos, " g").

listarAlimentosDisponiveis :-
    lerAlimentosComoString("alimentos.txt", ConteudoAlimentos),
    writeln("Alimentos disponíveis:"),
    writeln(ConteudoAlimentos).





















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
        submenu_exercicios_aerobicos(Usuario, NovoUsuario1),
        submenu_exercicios(NovoUsuario1, NovoUsuario)
    ; Opcao = "3" ->
        NovoUsuario = Usuario
    ; 
        writeln("Opção inválida.\n"),
        submenu_exercicios(Usuario, NovoUsuario)
    ).

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



------------------------------------------
exercicios_anaerobicos_do_dia(Usuario, ExerciciosDoDia)
exercicios_aerobicos_do_dia(Usuario, ExerciciosDoDia)
exercicios_anaerobicos_todos(Usuario, ExerciciosTodos)
exercicios_aerobicos_todos(Usuario, ExerciciosTodos)
adicionar_exercicio_anaerobico(Usuario, NovoUsuario1)
adicionar_exercicio_aerobico(Usuario, NovoUsuario1)
------------------------------------------