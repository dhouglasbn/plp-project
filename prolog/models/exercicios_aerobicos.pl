:- module(cadastrar_exercicio_aerobico, [cadastrar_exercicio_aerobico/5]).


cadastrar_exercicio_aerobico(NomeUsuario, NomeExercicio, Duracao, PesoUsuario, Data):-
    absolute_file_name("users/", CaminhoAbsoluto),
    atomic_list_concat([CaminhoAbsoluto, NomeUsuario, "/", Data, "/aerobicos.txt"], Caminho),
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