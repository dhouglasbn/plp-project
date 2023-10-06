:- module(altera_usuario_por_id, [altera_usuario_por_id/2]).

:- use_module(lista_usuarios).

altera_usuario_por_id(Id, NovoUsuario):-
    lista_usuarios(Lista),
    altera_usuario(Id, NovoUsuario, Lista, NovaLista),
    open("usuarios.txt", write, Fluxo),
    sobrescrever(Fluxo, NovaLista),
    close(Fluxo).

altera_usuario(_, _, [], []).
altera_usuario(IdUsuario, NovoUsuario, [Usuario|Resto], [Usuario|NovaLista]) :-
    (IdEncontrado|_) = Usuario,
    IdUsuario \== IdEncontrado,
    altera_usuario(IdUsuario, NovoUsuario, Resto, NovaLista).
altera_usuario(IdUsuario, NovoUsuario, [Usuario|Resto], NovaLista) :-
    (IdEncontrado|_) = Usuario,
    IdUsuario = IdEncontrado,
    append([NovoUsuario], Resto, NovaLista),
    altera_usuario(IdUsuario, NovoUsuario, Resto, Resto).

sobrescrever(_, []).
sobrescrever(Arquivo, [Linha|Resto]) :-
    write(Arquivo, Linha),
    write(Arquivo, " .\n"),
    sobrescrever(Arquivo, Resto).