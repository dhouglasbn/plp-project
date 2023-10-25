:- use_module(servicos/usuarios/lista_usuarios).
:- use_module(servicos/usuarios/pega_usuario_por_id).
:- use_module(servicos/usuarios/deleta_usuario_por_id).
:- use_module(servicos/usuarios/altera_usuario_por_id).
:- use_module(servicos/usuarios/patch_usuario).
:- use_module(servicos/usuarios/cadastra_usuario).
:- use_module(models/usuario).

main() :- 
    writeln("Boas vindas ao +Saude!\n"),
    writeln("Selecione uma das opções abaixo:\n"),
    writeln("1 - Criar Conta"),
    writeln("2 - Entrar em Conta"),
    writeln("3 - Sair\n"),
    read(Opcao),
    login(Opcao).

login(1) :- criar_conta(),!.
login(2) :- 
    writeln("\nDigite a senha:"),
    read(Senha),
    pega_usuario_por_id(Senha, Usuario),
    menu(Usuario),!.

login(3) :- halt.
login(_) :- 
    writeln("\nOpção inválida!\n"),
    main.

criar_conta() :-
    writeln("Digite seu nome: "),
    read(Nome),
    writeln("Digite sua senha: "),
    read(Senha),
    writeln("Escolha seu gênero (m)asculino ou (f)eminino: "),
    read(Genero),
    writeln("Digite sua idade: "),
    read(Idade),
    writeln("Digite seu peso: "),
    read(Peso),
    writeln("Digite sua altura: "),
    read(Altura),
    writeln("Digite sua meta de peso: "),
    read(Meta),

    read_integer(IdadeStr, Idade),
    read_float(PesoStr, Peso),
    read_float(AlturaStr, Altura),
    read_float(MetaStr, Meta),

    genero_valido(Genero),
    idade_valida(Idade),
    peso_valido(Peso),
    altura_valida(Altura),
    meta_valida(Meta),

    usuario(Senha, Nome, Genero, Idade, Peso, Altura, Meta, Usuario),

    cadastra_usuario(Usuario),   
    main()
    .

genero_valido("m") :- !.
genero_valido("f") :- !.
genero_valido(_) :-
    writeln("Gênero inválido. Use 'M' para masculino ou 'F' para feminino."),
    fail.

idade_valida(Idade) :-
    Idade > 0,
    Idade < 100, !.
idade_valida(_) :-
    writeln("Idade inválida. Deve ser um número entre 1 e 99."),
    fail.

peso_valido(Peso) :-
    Peso > 0.0, !.
peso_valido(_) :-
    writeln("Peso inválido. Deve ser um número positivo."),
    fail.

altura_valida(Altura) :-
    Altura > 0.0, !.
altura_valida(_) :-
    writeln("Altura inválida. Deve ser um número positivo."),
    fail.

meta_valida(Meta) :-
    Meta > 0.0, !.
meta_valida(_) :-
    writeln("Meta inválida. Deve ser um número positivo."),
    fail.

read_integer(Str, Int) :-
    catch(atom_number(Str, Int), _Error, fail).

read_float(Str, Float) :-
    catch(atom_number(Str, Float), _Error, fail).















menu(Usuario) :-
    usuario_get_nome(Usuario, Nome),
    write("Bem-vindo "),
    writeln(Nome),
    writeln("Escolha uma opção:\n"),
    writeln("1 - Configurar dados do usuario"),
    writeln("2 - Ver progresso calórico diário"),
    writeln("3 - Refeições"),
    writeln("4 - Exercícios"),
    writeln("5 - Sair e salvar\n"),
    read(Opcao),

    (Opcao = 1 ->
        mini_menu_configuracao(Usuario)
    ; Opcao = 2 ->
        writeln(Usuario),
        calcular_progresso_calorico(Usuario, Kfinal),
        print(Kfinal),
        metaProteins is (Kfinal * 0.25) / 4.0,
        print(metaProteins),
        metaLipids is (Kfinal * 0.25) / 9.0,
        print(metaLipids),
        metaCarbohydrates is (Kfinal * 0.5) / 4.0,
        print(metaCarbohydrates),
        menu(Usuario)

    ; Opcao = 3 ->
        mini_menu_refeicoes(Usuario)
    ; Opcao = 4 ->
        submenu_exercicios(Usuario)
    ; Opcao = 5 ->
        main()
    ; 
        writeln("Opção inválida!\n"),
        menu(Usuario)
    ).


mini_menu_configuracao(Usuario):-
    writeln("Escolha que tipo de dado voce deseja modificar:\n"),
    writeln("1 - Meta"),
    writeln("2 - Peso"),
    writeln("3 - Idade"),
    writeln("4 - Voltar"),
    read(Opcao),

    (Opcao = 1 ->
        writeln("Qual sua nova meta de peso?:\n"),
        read(MetaStr),
        read_float(MetaStr, Meta_Peso),
        usuario_set_meta_peso(Usuario, Meta_Peso, NovoUsuario),
        menu(NovoUsuario)
    ; Opcao = 2 ->
        writeln("Qual seu novo peso?:\n"),
        read(PesoStr),
        read_float(PesoStr, Peso),
        usuario_set_peso(Usuario, Peso, NovoUsuario),
        menu(NovoUsuario)
    ; Opcao = 3 ->
        writeln("Qual é a sua idade?:\n"),
        read(IdadeStr),
        read_integer(IdadeStr, Idade),
        usuario_set_idade(Usuario, Idade, NovoUsuario),
        menu(NovoUsuario)
    ; Opcao = 4 ->
        menu(Usuario)
    ; 
        writeln("Opção inválida!\n"),
        mini_menu_configuracao(Usuario)
    ).

calcular_progresso_calorico(Usuario, Kfinal):-
    usuario_get_genero(Usuario, Genero),
    usuario_get_peso(Usuario, Peso),
    usuario_get_altura(Usuario, Altura),
    usuario_get_meta_peso(Usuario, Meta),
    caloriasManterPeso(Genero, Peso, Altura, Calorias),

    (Peso > Meta -> 
    caloriasDiariasPerderPeso(Calorias, Peso, MetaPeso, Kcal),
    Kfinal is Kcal
    ;
    Peso < Meta -> 
    caloriasDiariasGanharPeso(Calorias, Peso, MetaPeso, Kcal),
    Kfinal is Kcal
    ;
    Kfinal is Calorias).

caloriasManterPeso("m", Peso, Altura, Calorias) :-
    Calorias is 888.362 + (13.397 * Peso) + (4.799 * Altura).

caloriasManterPeso("f", Peso, Altura, Calorias) :-
    Calorias is 447.593 + (9.247 * Peso) + (3.098 * Altura).

caloriasManterPeso(_, _, 0.0).

caloriasDiariasPerderPeso(KPadrao, Peso, MetaPeso, Calorias) :-
    Calorias is KPadrao - (25 * (Peso - MetaPeso)).

caloriasDiariasGanharPeso(KPadrao, Peso, MetaPeso, Calorias) :-
    Calorias is KPadrao + (25 * (MetaPeso - Peso)).



















































mini_menu_refeicoes(Usuario) :-
    writeln("\nEscolha que tipo de refeição com que você quer interagir"),
    writeln("1 - Café"),
    writeln("2 - Almoço"),
    writeln("3 - Lanche"),
    writeln("4 - Janta"),
    writeln("5 - Voltar\n"),
    read(Opcao),

    (Opcao = 1 ->
        editar_refeicao("Café", Usuario)
    ; Opcao = 2 ->
        editar_refeicao("Almoço", Usuario)
    ; Opcao = 3 ->
        editar_refeicao("Lanche", Usuario)
    ; Opcao = 4 ->
        editar_refeicao("Janta", Usuario)
    ; Opcao = 5 ->
        menu(Usuario)
    ; 
        writeln("Opção inválida.\n"),
        mini_menu_refeicoes(Usuario)
    ).


editarRefeicao(Nome, Usuario) :-
    write('Editando '), write(Nome), nl,

    (Nome = 'Café' -> ListaRefeicao = cafe(Usuario)
    ; Nome = 'Almoço' -> ListaRefeicao = almoco(Usuario)
    ; Nome = 'Lanche' -> ListaRefeicao = lanche(Usuario)
    ; Nome = 'Janta' -> ListaRefeicao = janta(Usuario)
    ),



    write('Escolha uma opção:'), nl,
    write('1 - Adicionar alimento'), nl,
    write('2 - Ver valor nutricional total'), nl,
    write('3 - Ver alimentos registrados'), nl,
    write('4 - Voltar'), nl,
    read(Opcao),

    (Opcao = 1 -> adicionarAlimento(id, Usuario, ListaRefeicao, Nome)
    ; Opcao = 2 -> calcularValorNutricionalTotal(ListaRefeicao), editarRefeicao(Nome, Usuario)
    ; Opcao = 3 -> listarAlimentosDisponiveis, editarRefeicao(Nome, Usuario)
    ; Opcao = 4 -> mini_menu_refeicoes(Usuario)
    ; write('Opção inválida.'), nl, editarRefeicao(Nome, Usuario)
    ).


adicionarAlimento(id, Usuario, ListaRefeicao, Nome) :-
    writeln("Digite o id do alimento que deseja adicionar:"),
    read(id),
    obterAlimentoPeloId(TXT, id, Alimento),

    writeln("Digite quantos gramas de alimento: "),
    read(QuantiaAlimento),
    read_integer(QuantiaAlimento, Gramas),

    criarAlimentoRegistrado(Alimento, Gramas, AlimentoRegistrado),

    adicionarAlimentoNaRefeicao(ListaRefeicao, AlimentoRegistrado),
    editarRefeicao(Nome, Usuario).






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





















submenu_exercicios(Usuario) :-
    writeln("\nEscolha uma opção:"),
    writeln("1 - Exercícios Anaeróbicos"),
    writeln("2 - Exercícios Aeróbicos"),
    writeln("3 - Voltar ao Menu Principal\n"),
    read(Opcao),

    (Opcao = 1 ->
        submenu_exercicios_anaerobicos(Usuario)
    ; Opcao = 2 ->
        submenu_exercicios_aerobicos(Usuario)
    ; Opcao = 3 ->
        menu(Usuario)
    ; 
        writeln("Opção inválida.\n"),
        submenu_exercicios(Usuario)
    ).

submenu_exercicios_anaerobicos(Usuario) :-
    writeln("\nExercícios Anaeróbicos:"),
    writeln("1 - Ver exercícios do dia"),
    writeln("2 - Ver todos os exercícios já feitos"),
    writeln("3 - Adicionar exercício realizado"),
    writeln("4 - Voltar\n"),
    read(Opcao),

    (Opcao = 1 ->
        exercicios_anaerobicos_do_dia(Usuario, ExerciciosDoDia),
        writeln(ExerciciosDoDia),
        submenu_exercicios_anaerobicos(Usuario)
    ; Opcao = 2 ->
        exercicios_anaerobicos_todos(Usuario, ExerciciosTodos),
        writeln(ExerciciosTodos),
        submenu_exercicios_anaerobicos(Usuario)
    ; Opcao = 3 ->
        adicionar_exercicio_anaerobico(Usuario)
    ; Opcao = 4 ->
        submenu_exercicios(Usuario)
    ; 
        writeln("Opção inválida.\n"),
        submenu_exercicios_anaerobicos(Usuario)
    ).

submenu_exercicios_aerobicos(Usuario, NovoUsuario) :-
    writeln("\nExercícios Aeróbicos:"),
    writeln("1 - Ver exercícios do dia"),
    writeln("2 - Ver todos os exercícios já feitos"),
    writeln("3 - Adicionar exercício realizado"),
    writeln("4 - Voltar\n"),
    read(Opcao),

    (Opcao = 1 ->
        exercicios_aerobicos_do_dia(Usuario, ExerciciosDoDia),
        writeln(ExerciciosDoDia),
        submenu_exercicios_aerobicos(Usuario)
    ; Opcao = 2 ->
        exercicios_aerobicos_todos(Usuario, ExerciciosTodos),
        writeln(ExerciciosTodos),
        submenu_exercicios_aerobicos(Usuario)
    ; Opcao = 3 ->
        adicionar_exercicio_aerobico(Usuario)
    ; Opcao = 4 ->
        submenu_exercicios(Usuario)
    ; 
        writeln("Opção inválida."),
        submenu_exercicios_aerobicos(Usuario)
    ).