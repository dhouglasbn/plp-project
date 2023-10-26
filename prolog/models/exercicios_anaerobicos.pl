:- module(cadastrar_exercicio_anaerobico, [cadastrar_exercicio_anaerobico/5 , calcular_perda_calorica_anaerobico/3]).

calcular_perda_calorica_anaerobico(PesoUsuario, DuracaoTreino, PerdaCalorica):-
    PerdaCalorica = (PesoUsuario * DuracaoTreino) * 4.

cadastrar_exercicio_anaerobico(NomeUsuario, NomeExercicio, Duracao, PesoUsuario, Data):-
    absolute_file_name("users/", CaminhoAbsoluto),
    atomic_list_concat([CaminhoAbsoluto, NomeUsuario, "/", Data, "/anaerobicos.txt"], Caminho),
    atomic_list_concat(['"', NomeExercicio, '"'], ExercicioNome),
    Exercicio = (ExercicioNome|Duracao|PesoUsuario),
    open(Caminho, append, Fluxo),
    write(Fluxo, Exercicio), write(Fluxo, ".\n"), nl,
    close(Fluxo),
    cadastrar_em_todos_os_exercicios(CaminhoAbsoluto, NomeUsuario, ExercicioNome).

cadastrar_em_todos_os_exercicios(CaminhoAbsoluto, NomeUsuario, ExercicioNome):-
    atomic_list_concat([CaminhoAbsoluto, NomeUsuario, "/todos-exercicios.txt"], Caminho),
    open(Caminho, append, Fluxo),
    write(Fluxo, ExercicioNome), write(Fluxo, ".\n"), nl,
    close(Fluxo).