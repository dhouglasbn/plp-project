:- use_module(servicos/usuarios/lista_usuarios).
:- use_module(servicos/usuarios/pega_usuario_por_id).
:- use_module(servicos/usuarios/deleta_usuario_por_id).
:- use_module(servicos/usuarios/altera_usuario_por_id).
:- use_module(servicos/usuarios/patch_usuario).
:- use_module(servicos/usuarios/cadastra_usuario).
:- use_module(servicos/registros/registrar_dia).
:- use_module(servicos/exerciciosanaerobicos/listar_exercicios_anaerobicos).
:- use_module(servicos/exerciciosaerobicos/listar_exercicios_aerobicos).
:- use_module(servicos/exerciciosanaerobicos/listar_exercicios_anaerobicos_do_dia).
:- use_module(servicos/exerciciosaerobicos/listar_exercicios_aerobicos_do_dia).
:- use_module(servicos/todosexercicios/listar_todos_exercicios).
:- use_module(servicos/alimentos/listar_alimentos).
:- use_module(servicos/alimentos/registrar_alimento).
:- use_module(servicos/alimentos/pegar_alimento_por_id).
:- use_module(servicos/alimentos/calcula_macros_do_dia).
:- use_module(servicos/alimentos/listar_alimentos_do_dia).
:- use_module(models/exercicios_anaerobicos).
:- use_module(models/exercicios_aerobicos).
:- use_module(models/usuario).
:- use_module(models/alimento).
:- use_module(library(date)).
:- use_module(library(clpq)).

main() :-
    writeln("==================================="),
    writeln("       Boas vindas ao +Saude!"),
    writeln("===================================\n"),
    writeln("Selecione uma das opções abaixo:"),
    writeln("===================================\n"),
    writeln("1 - Criar Conta"),
    writeln("2 - Entrar em Conta"),
    writeln("3 - Sair\n"),
    writeln("===================================\n"),
    read(Opcao),
    login(Opcao).

login(1) :- criar_conta(),!.
login(2) :-
    writeln("\nDigite o nome de usuário:"),
    read(UsuarioNomeEntrada),
    string_lower(UsuarioNomeEntrada, NomeMinusculo),
    quebrar_e_substituir(NomeMinusculo, NomeEntradaFormatado),


    writeln("\nDigite a senha:"),
    read(Senha),
    pega_usuario_por_id(Senha, Usuario),

    usuario_get_nome(Usuario, NomeDoTXT),
    (Usuario = "NOUSER" ; NomeDoTXT \== NomeEntradaFormatado
    -> writeln("\nUsuário inexistente!."),
    login(2)
    ; usuario_get_nome(Usuario, NomeUsuario),
    pegar_data_atual(Data),
    (verifica_dia_atual(Data, NomeUsuario) -> menu(Usuario)
        ; registrar_dia(Data, NomeUsuario), menu(Usuario))).


login(3) :- halt.
login(_) :-
    writeln("\nOpção inválida!\n"),
    main.

criar_conta() :-
    writeln("Digite seu nome: "),
    read(Nome),
    writeln("Digite sua senha: "),
    read(Senha),
    senha_unica(Senha),
    writeln("Escolha seu gênero (m)asculino ou (f)eminino: "),
    read(Genero),
    genero_valido(Genero),
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

    idade_valida(Idade),
    peso_valido(Peso),
    altura_valida(Altura),
    meta_valida(Meta),

    usuario(Senha, Nome, Genero, Idade, Peso, Altura, Meta, Usuario),

    cadastra_usuario(Usuario),
    main()
    .

senha_unica(Senha):- lista_usuarios(Lista), valida_senha(Senha, Lista).

valida_senha(_, []):- !.
valida_senha(Senha, [UsuarioHead|Tail]):-
    usuario_get_senha(UsuarioHead, SenhaHead),
    (Senha =:= SenhaHead
    -> writeln("Essa senha já existe! Tente novamente uma outra senha."), fail
    ; valida_senha(Senha, Tail)).

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
    write("\nBem-vindo "), write(Nome), write("!\n"),
    writeln("Escolha uma opção:\n"),
    writeln("===================================\n"),
    writeln("1 - Configurar dados do usuario"),
    writeln("2 - Ver progresso calórico diário"),
    writeln("3 - Refeições"),
    writeln("4 - Exercícios"),
    writeln("5 - Desconectar\n"),
    writeln("===================================\n"),
    read(Opcao),

    (Opcao = 1 ->
        mini_menu_configuracao(Usuario)
    ; Opcao = 2 ->
        calcular_progresso_calorico(Usuario, Kfinal),
        usuario_set_meta_kcal(Usuario, Kfinal, NovoUsuario),
        usuario_get_kcal_atual(NovoUsuario, KcalAtual),
        usuario_get_senha(NovoUsuario, Senha),
        altera_usuario_por_id(Senha, NovoUsuario),

        calcula_macros(Kfinal, MetaProteins, MetaLipids, MetaCarbohydrates),
        arredonda_para_uma_casa_decimal(KcalAtual, KcalAtualArredondado),
        arredonda_para_uma_casa_decimal(Kfinal, KfinalArredondado),


        write("KcalAtual/Meta de Kcal: "),
        write(KcalAtualArredondado), write("/"), write(KfinalArredondado),
        write("\n"),
        write("Meta de Proteínas: "), write(MetaProteins), write("\n"),
        write("Meta de Lipídios: "), write(MetaLipids), write("\n"),
        write("Meta de Carboidratos: "), write(MetaCarbohydrates), write("\n"),
        menu(NovoUsuario)
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

calcula_macros(
    Kfinal,
    MetaProteinsArredondado,
    MetaLipidsArredondado,
    MetaCarbohydratesArredondado
    ):-
        MetaProteins is Kfinal * 0.25 / 4.0,
        MetaLipids is Kfinal * 0.25 / 9.0,
        MetaCarbohydrates is Kfinal * 0.5 / 4.0,
        arredonda_para_uma_casa_decimal(MetaProteins, MetaProteinsArredondado),
        arredonda_para_uma_casa_decimal(MetaLipids, MetaLipidsArredondado),
        arredonda_para_uma_casa_decimal(MetaCarbohydrates, MetaCarbohydratesArredondado).


arredonda_para_uma_casa_decimal(Numero, Resultado) :-
    Resultado is round(Numero * 10) / 10.

mini_menu_configuracao(Usuario):-
    writeln("Escolha que tipo de dado voce deseja modificar:\n"),
    writeln("===================================\n"),
    writeln("1 - Meta de Peso"),
    writeln("2 - Peso"),
    writeln("3 - Idade"),
    writeln("4 - Voltar\n"),
    writeln("===================================\n"),
    read(Opcao),

    (Opcao = 1 ->
        writeln("Qual sua nova meta de peso?:\n"),
        read(Meta_Peso),
        usuario_set_meta_peso(Usuario, Meta_Peso, NovoUsuario),
        usuario_get_senha(NovoUsuario, Senha),
        altera_usuario_por_id(Senha, NovoUsuario),
        menu(NovoUsuario)
    ; Opcao = 2 ->
        writeln("Qual seu novo peso?:\n"),
        read(Peso),
        usuario_set_peso(Usuario, Peso, NovoUsuario),
        usuario_get_senha(NovoUsuario, Senha),
        altera_usuario_por_id(Senha, NovoUsuario),
        menu(NovoUsuario)
    ; Opcao = 3 ->
        writeln("Qual é a sua idade?:\n"),
        read(Idade),
        usuario_set_idade(Usuario, Idade, NovoUsuario),
        usuario_get_senha(NovoUsuario, Senha),
        altera_usuario_por_id(Senha, NovoUsuario),
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
    usuario_get_meta_peso(Usuario, MetaPeso),
    atom_string(Genero, GeneroString),
    caloriasManterPeso(GeneroString, Peso, Altura, Calorias),

    (Peso > MetaPeso ->
    caloriasDiariasPerderPeso(Calorias, Peso, MetaPeso, Kcal),
    Kfinal is Kcal
    ;
    Peso < MetaPeso ->
    caloriasDiariasGanharPeso(Calorias, Peso, MetaPeso, Kcal),
    Kfinal is Kcal
    ;
    Kfinal is Calorias
    ).

caloriasManterPeso("m", Peso, Altura, Calorias) :-
    Calorias is 888.362 + (13.397 * Peso) + (4.799 * Altura).

caloriasManterPeso("f", Peso, Altura, Calorias) :-
    Calorias is 447.593 + (9.247 * Peso) + (3.098 * Altura).

caloriasDiariasPerderPeso(Calorias, Peso, MetaPeso, Kcal) :-
    Kcal is Calorias - (25 * (Peso - MetaPeso)).

caloriasDiariasGanharPeso(Calorias, Peso, MetaPeso, Kcal) :-
    A is MetaPeso - Peso,
    B is 25 * A,
    Kcal is Calorias + B.



















































mini_menu_refeicoes(Usuario) :-
    writeln("\nEscolha que tipo de refeição com que você quer interagir"),
    writeln("===================================\n"),
    writeln("1 - Adicionar alimento"),
    writeln("2 - Ver valor nutricional total"),
    writeln("3 - Ver alimentos registrados"),
    writeln("4 - Adicionar alimento a uma refeição"),
    writeln("5 - Voltar\n"),
    writeln("===================================\n"),
    read(Opcao),

    (Opcao = 1 ->
    listar_alimentos(Lista),
	listar_alimentos_formatados(Lista), nl,
	writeln("Escolha o alimento pelo índice:"),
	read(IdAlimento),
	writeln("Escolha a quantidade em gramas:"),
	read(Gramas),
	pegar_alimento_por_id(IdAlimento, Alimento),
	usuario_get_nome(Usuario, NomeUsuario),
	pegar_data_atual(Data),
	alimento_set_quantidade(Alimento, Gramas, 0, NovoAlimento),

	get_kcal(NovoAlimento, KcalAlimento),
	usuario_get_kcal_atual(Usuario, KcalUsuario),
	KcalAtual is KcalAlimento + KcalUsuario,
	usuario_set_kcal_atual(Usuario, KcalAtual, NovoUsuario),
	usuario_get_senha(NovoUsuario, Senha),
	altera_usuario_por_id(Senha, NovoUsuario),


	registrar_alimento(NovoAlimento, NomeUsuario, Data),
    mini_menu_refeicoes(NovoUsuario)

    ; Opcao = 2 ->
	usuario_get_nome(Usuario, NomeUsuario),
	pegar_data_atual(Data),
    	calcula_macros_do_dia(NomeUsuario, Data, Tupla),
	tupla_formatada(Tupla),
   	mini_menu_refeicoes(Usuario)

    ; Opcao = 3 ->
	usuario_get_nome(Usuario, NomeUsuario),
	pegar_data_atual(Data),
	listar_alimentos_do_dia(NomeUsuario, Data, Lista),
    	listar_alimentos_formatados(Lista), nl,
    	mini_menu_refeicoes(Usuario)

    ; Opcao = 4 ->
    listar_alimentos(Lista),
	listar_alimentos_formatados(Lista),
	writeln("Escolha o alimento pelo índice:"),
	read(IdAlimento),
	writeln("Escolha a quantidade em gramas:"),
	read(Gramas),
	writeln("Escolha a refeição (1 para café, 2 para almoço, 3 para lanche, 4 para janta):"),
	read(IdRefeicao),
	pegar_alimento_por_id(IdAlimento, Alimento),
	usuario_get_nome(Usuario, NomeUsuario),
	pegar_data_atual(Data),
	alimento_set_quantidade(Alimento, Gramas, IdRefeicao, NovoAlimento),
    	get_kcal(NovoAlimento, KcalAlimento),
    	usuario_get_kcal_atual(Usuario, KcalUsuario),
    	KcalAtual is KcalAlimento + KcalUsuario,
    	usuario_set_kcal_atual(Usuario, KcalAtual, NovoUsuario),
    	usuario_get_senha(NovoUsuario, Senha),
    	altera_usuario_por_id(Senha, NovoUsuario),
	registrar_alimento(NovoAlimento, NomeUsuario, Data),
    	mini_menu_refeicoes(NovoUsuario)

    ; Opcao = 5 ->
        menu(Usuario)
    ;
        writeln("Opção inválida.\n"),
        mini_menu_refeicoes(Usuario)
    ).

















submenu_exercicios(Usuario) :-
    writeln("\nEscolha uma opção:"),
    writeln("===================================\n"),
    writeln("1 - Exercícios Anaeróbicos"),
    writeln("2 - Exercícios Aeróbicos"),
    writeln("3 - Voltar ao Menu Principal\n"),
    writeln("===================================\n"),
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
    writeln("===================================\n"),
    writeln("1 - Ver exercícios do dia"),
    writeln("2 - Ver todos os exercícios já feitos"),
    writeln("3 - Adicionar exercício realizado"),
    writeln("4 - Sugerir Exercicio"),
    writeln("5 - Voltar\n"),
    writeln("===================================\n"),
    read(Opcao),

    (Opcao = 1 ->
        exercicios_anaerobicos_do_dia(Usuario),
        submenu_exercicios_anaerobicos(Usuario)
    ; Opcao = 2 ->
        todos_exercicios_feitos(Usuario),
        submenu_exercicios_anaerobicos(Usuario)
    ; Opcao = 3 ->
        adicionar_exercicio_anaerobico(Usuario)



    ; Opcao = 4 ->
        exercicio_aleatorio_anaerobico(Exercicio),
        writeln("Exercício Sugerido:"),
        (NomeExercicio | _) = Exercicio,
        writeln(NomeExercicio),
        submenu_exercicios_anaerobicos(Usuario)
    ; Opcao = 5 ->
        submenu_exercicios(Usuario)
    ;
        writeln("Opção inválida.\n"),
        submenu_exercicios_anaerobicos(Usuario)
    ).

submenu_exercicios_aerobicos(Usuario) :-
    writeln("\nExercícios Aeróbicos:"),
    writeln("===================================\n"),
    writeln("1 - Ver exercícios do dia"),
    writeln("2 - Ver todos os exercícios já feitos"),
    writeln("3 - Adicionar exercício realizado"),
    writeln("4 - Sugerir Exercicio"),
    writeln("5 - Voltar\n"),
    writeln("===================================\n"),
    read(Opcao),

    (Opcao = 1 ->
        exercicios_aerobicos_do_dia(Usuario),
        submenu_exercicios_aerobicos(Usuario)
    ; Opcao = 2 ->
        todos_exercicios_feitos(Usuario),
        submenu_exercicios_aerobicos(Usuario)
    ; Opcao = 3 ->
        adicionar_exercicio_aerobico(Usuario)
    ; Opcao = 4 ->
        exercicio_aleatorio_aerobico(Exercicio),
        writeln("Exercício Sugerido:"),
        (NomeExercicio | _) = Exercicio,
        writeln(NomeExercicio),
        submenu_exercicios_aerobicos(Usuario)
    ; Opcao = 5 ->
        submenu_exercicios(Usuario)
    ;
        writeln("Opção inválida."),
        submenu_exercicios_aerobicos(Usuario)
    ).

% Pegar data atual
pegar_data_atual(Data) :-
    get_time(Stamp),
    stamp_date_time(Stamp, DateTime, 'UTC'),
    date_time_value(day, DateTime, Dia),
    date_time_value(month, DateTime, Mes),
    date_time_value(year, DateTime, Ano),
    atomic_list_concat([Dia, Mes, Ano], Data).






adicionar_exercicio_anaerobico(Usuario):-
    write("Lista de exercicios anaerobicos: "), nl,
    listar_exercicios_anaerobicos(),
    write("\nEscolha um exercício: "),
    read(NomeExercicio),
    verifica_exercicio_anaerobico(Usuario, NomeExercicio),
    write("\nDuração do exercício: "),
    read(Duracao),
    usuario_get_peso(Usuario, PesoUsuario),
    pegar_data_atual(Data),
    usuario_get_nome(Usuario, NomeUsuario),
    cadastrar_exercicio_anaerobico(NomeUsuario, NomeExercicio, Duracao, PesoUsuario, Data),


    calcular_perda_calorica_anaerobico(PesoUsuario, Duracao, PerdaCalorica),
    usuario_get_kcal_atual(Usuario, Kcal),
    Kcal_atual is Kcal - PerdaCalorica,
    usuario_set_kcal_atual(Usuario, Kcal_atual, NovoUsuario),
    usuario_get_senha(NovoUsuario, Senha),
    altera_usuario_por_id(Senha, NovoUsuario),


    write("Exercicio registrado com sucesso."), nl,
    submenu_exercicios_anaerobicos(NovoUsuario).


verifica_exercicio_anaerobico(Usuario, NomeExercicio):-
    leitura_exercicios(Exercicios),
    exercicio_anaerobico_existe(Usuario, NomeExercicio, Exercicios).

exercicio_anaerobico_existe(Usuario, _, []):-
    writeln("O nome do exercício está incorreto! Tente novamente."),
    adicionar_exercicio_anaerobico(Usuario), !.
exercicio_anaerobico_existe(_, NomeExercicio, [(Nome|_)|_]):-
    NomeExercicio = Nome, !.
exercicio_anaerobico_existe(Usuario, NomeExercicio, [_|Tail]):-
    exercicio_anaerobico_existe(Usuario, NomeExercicio, Tail).


adicionar_exercicio_aerobico(Usuario):-
    write("Lista de exercicios aerobicos: "), nl,
    listar_exercicios_aerobicos(),
    write("\nEscolha um exercício: "),
    read(NomeExercicio),
    verifica_exercicio_aerobico(Usuario, NomeExercicio, ConstanteCalorica),
    write("\nDuração do exercício: "),
    read(Duracao),
    usuario_get_peso(Usuario, PesoUsuario),
    pegar_data_atual(Data),
    usuario_get_nome(Usuario, NomeUsuario),
    cadastrar_exercicio_aerobico(NomeUsuario, NomeExercicio, Duracao, PesoUsuario, Data),


    calcular_perda_calorica_aerobico(
        PesoUsuario,
        Duracao,
        NomeExercicio,
        ConstanteCalorica,
        PerdaCalorica),
    usuario_get_kcal_atual(Usuario, Kcal),
    Kcal_atual is Kcal - PerdaCalorica,
    usuario_set_kcal_atual(Usuario, Kcal_atual, NovoUsuario),
    usuario_get_senha(NovoUsuario, Senha),
    altera_usuario_por_id(Senha, NovoUsuario),
    write("Exercicio registrado com sucesso."), nl,
    submenu_exercicios_aerobicos(NovoUsuario).


verifica_exercicio_aerobico(Usuario, NomeExercicio, ConstanteCalorica):-
    leitura_exercicios_aerobicos(Exercicios),
    exercicio_aerobico_existe(Usuario, NomeExercicio, Exercicios, ConstanteCalorica).

exercicio_aerobico_existe(Usuario, _, [], _):-
    writeln("O nome do exercício está incorreto! Tente novamente."),
    adicionar_exercicio_aerobico(Usuario), !.
exercicio_aerobico_existe(_, NomeExercicio, [(Nome|ConstanteCalorica)|_], ConstanteCalorica):-
    NomeExercicio = Nome, !.
exercicio_aerobico_existe(Usuario, NomeExercicio, [_|Tail], ConstanteCalorica):-
    exercicio_aerobico_existe(Usuario, NomeExercicio, Tail, ConstanteCalorica).


exercicios_anaerobicos_do_dia(Usuario):-
    write("Lista de exercicios anaerobicos: "), nl,
    pegar_data_atual(Data),
    usuario_get_nome(Usuario, NomeUsuario),
    listar_exercicios_anaerobicos_do_dia(Data, NomeUsuario), nl.

exercicios_aerobicos_do_dia(Usuario):-
    write("Lista de exercicios aerobicos: "), nl,
    pegar_data_atual(Data),
    usuario_get_nome(Usuario, NomeUsuario),
    listar_exercicios_aerobicos_do_dia(Data, NomeUsuario), nl.


todos_exercicios_feitos(Usuario):-
    write("\nExercícios realizados pelo Usuario: "),
    usuario_get_nome(Usuario, NomeUsuario),
    write(NomeUsuario), nl,
    listar_todos_exercicios(NomeUsuario).

tupla_formatada((Kcal|Proteina|Gordura|Carboidrato)):-
atomic_list_concat([
"Calorias: ", Kcal, "G\n",
"Proteínas: ", Proteina, "G\n",
"Gorduras: ", Gordura, "G\n",
"Carboidratos: ", Carboidrato, "G\n"], Ftupla),
write(Ftupla).
