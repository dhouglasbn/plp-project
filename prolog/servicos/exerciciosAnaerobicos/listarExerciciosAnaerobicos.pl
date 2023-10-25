:- module(listar_exercicios_anaerobicos, [listar_exercicios_anaerobicos/0]).

listar_exercicios_anaerobicos():-
    leitura_exercicios(Leitura),
    remover_ultimo(Leitura, Lista),
    remove_primeiro(Lista, ListaFormatada),
    listar_exercicios(ListaFormatada).

leitura_exercicios(Leitura):-
    open('../../dados/exerciciosAnaerobicos.txt', read, Fluxo),
    ler_exercicios(Fluxo, Leitura),
    close(Fluxo).

ler_exercicios(F, []):-
    at_end_of_stream(F), !.
ler_exercicios(F, [X|L]):-
    \+ at_end_of_stream(F), !,
    read(F, X),
    ler_exercicios(F, L).

remover_ultimo([_], []).
remover_ultimo([X|Resto], [X|Resultado]) :-
    remover_ultimo(Resto, Resultado).

remove_primeiro([_|T], T).

% Predicado para listar todos os exercícios
listar_exercicios([]).
listar_exercicios([(Nome | PartesCorpo) | Resto]) :-
    write("Nome: "), write(Nome), nl,
    write("Partes do Corpo: "), write(PartesCorpo), nl, nl,
    listar_exercicios(Resto), halt.