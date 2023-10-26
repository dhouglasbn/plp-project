:- module(registrar_alimento, [registrar_alimento/1]).

:- consult('../../models/alimento').

registrar_alimento(Alimento, NomeUsuario, Data):-
    absolute_file_name("users/", CaminhoAbsoluto),
    atomic_list_concat([CaminhoAbsoluto, NomeUsuario, "/", Data, "/alimento.txt" ], PastaUsuario),
    open(PastaUsuario, append, Fluxo),
    write(Fluxo, Alimento), write(Fluxo, ".\n"), nl,
    close(Fluxo).
