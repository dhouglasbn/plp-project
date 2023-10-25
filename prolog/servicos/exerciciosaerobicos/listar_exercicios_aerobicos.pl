:- module(listar_exercicios_aerobicos, [
    listar_exercicios_aerobicos/0,
    leitura_exercicios_aerobicos/1,
    exercicio_aleatorio_aerobico/1
    ]).

listar_exercicios_aerobicos():-
    leitura_exercicios_aerobicos(Leitura),
    listar_exercicios(Leitura).

leitura_exercicios_aerobicos(Leitura):-
    open('dados/exerciciosAerobicos.txt', read, Fluxo),
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

% Predicado para obter um exercício aleatório aeróbico.
exercicio_aleatorio_aerobico(Exercicio) :-
    leitura_exercicios_aerobicos(Leitura),
    length(Leitura, ListLength),
    random(1, ListLength, RandomIndex),
    nth1(RandomIndex, Leitura, Exercicio).