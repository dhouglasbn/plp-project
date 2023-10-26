:- module(registrar_alimento, [registrar_alimento/3]).

:- consult(calcula_macros_do_dia).

registrar_alimento(Alimento, NomeUsuario, Data):-
    absolute_file_name("users/", CaminhoAbsoluto),
    atomic_list_concat([CaminhoAbsoluto, NomeUsuario, "/", Data, "/alimento.txt" ], PastaUsuario),
    open(PastaUsuario, append, Fluxo),
    (_|NomeAlimento|_) = Alimento,
    atomic_list_concat(['"', NomeAlimento, '"'], AlimentoNome),
    set_nome_alimento(Alimento, AlimentoNome, NovoAlimento),
    write(Fluxo, NovoAlimento), write(Fluxo, ".\n"), nl,
    close(Fluxo).
