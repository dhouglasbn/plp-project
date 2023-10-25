:- module(listar_exercicios_anaerobicos_do_dia, [listar_exercicios_anaerobicos_do_dia/2]).

listar_exercicios_anaerobicos_do_dia(Data, NomeUsuario):-
    absolute_file_name("users/", CaminhoAbsoluto),
    atomic_list_concat([CaminhoAbsoluto, NomeUsuario, "/", Data, "/anaerobicos.txt"], PastaUsuario),
    leitura_exercicios_anaerobicos(Data, PastaUsuario, Leitura),
    remover_ultimo(Leitura, Lista),
    listar_exercicios(Lista).


leitura_exercicios_anaerobicos(Data, PastaUsuario, Leitura):-
    open(PastaUsuario, read, Fluxo),
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


% Predicado para listar todos os exercícios
listar_exercicios([]).
listar_exercicios([(Nome|_|_) | Resto]) :-
    write("Nome: "), write(Nome), nl,
    listar_exercicios(Resto).