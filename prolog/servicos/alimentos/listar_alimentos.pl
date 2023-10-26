:- module(listar_alimentos, [listar_alimentos/1, listar_alimentos/2, listar_alimentos_formatados/1]).

listar_alimentos(Lista):-
    open('dados/alimentos.txt', read, Fluxo),
    ler_alimentos(Fluxo, Leitura),
    close(Fluxo),
    remover_ultimo(Leitura, Lista).

listar_alimentos(Caminho, Lista):-
    open(Caminho, read, Fluxo),
    ler_alimentos(Fluxo, Leitura),
    close(Fluxo),
    remover_ultimo(Leitura, Lista).

% Predicado para listar todos os alimentos formatados
listar_alimentos_formatados([]).
listar_alimentos_formatados([(ID | NomeDoAlimento | _) | Resto]) :-
    atomic_list_concat([ID, " - ", NomeDoAlimento], AlimentoFormatado),
    write(AlimentoFormatado), nl,
    listar_alimentos_formatados(Resto).

ler_alimentos(F, []):-
    at_end_of_stream(F), !.
ler_alimentos(F, [X|L]):-
    \+ at_end_of_stream(F), !,
    read(F, X),
    ler_alimentos(F, L).

remover_ultimo([_], []):-!.
remover_ultimo([X|Resto], [X|Resultado]) :-
    remover_ultimo(Resto, Resultado).
