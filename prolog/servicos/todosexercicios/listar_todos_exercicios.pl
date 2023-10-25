:- module(listar_todos_exercicios, [listar_todos_exercicios/1]).


listar_todos_exercicios(NomeUsuario):-
    listar_exercicios_aerobicos_anaerobicos(NomeUsuario, Leitura),
    remover_ultimo(Leitura, Lista),
    listar_exercicios(Lista).

listar_exercicios_aerobicos_anaerobicos(NomeUsuario, Leitura):-
    absolute_file_name("users/", CaminhoAbsoluto),
    atomic_list_concat([CaminhoAbsoluto, NomeUsuario, "/todos-exercicios.txt"], TodosExercicios),
    open(TodosExercicios, read, Fluxo),
    ler_exercicios(Fluxo, Leitura),
    close(Fluxo).

ler_exercicios(F, []):-
    at_end_of_stream(F), !.
ler_exercicios(F, [X|L]):-
    \+ at_end_of_stream(F), !,
    read(F, X),
    ler_exercicios(F, L).

% Predicado para listar todos os exercícios
listar_exercicios([]):- !.
listar_exercicios([(Nome) | Resto]) :-
    write(Nome), write("\n"),
    listar_exercicios(Resto).

remover_ultimo([_], []).
remover_ultimo([X|Resto], [X|Resultado]) :-
    remover_ultimo(Resto, Resultado).