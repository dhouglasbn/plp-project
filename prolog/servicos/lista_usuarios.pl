:- module(lista_usuarios, [lista_usuarios/1]).

lista_usuarios(Lista):- 
    open('dados/usuarios.txt', read, Fluxo),
    ler_usuarios(Fluxo, Leitura),
    close(Fluxo),
    remover_ultimo(Leitura, Lista).


ler_usuarios(F, []):-
    at_end_of_stream(F), !.
ler_usuarios(F, [X|L]):-
    \+ at_end_of_stream(F), !,
    read(F, X),
    ler_usuarios(F, L).

remover_ultimo([_], []).
remover_ultimo([X|Resto], [X|Resultado]) :-
    remover_ultimo(Resto, Resultado).