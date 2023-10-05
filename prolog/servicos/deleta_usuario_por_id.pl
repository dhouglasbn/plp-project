:- module(deleta_usuario_por_id, [deleta_usuario_por_id/1]).

:- use_module(lista_usuarios).

deleta_usuario_por_id(Id):-
    lista_usuarios(Lista),
    remover_usuario(Id, Lista, NovaLista),
    open("usuarios.txt", write, Fluxo),
    sobrescrever(Fluxo, NovaLista),
    close(Fluxo).

remover_usuario(_, [], []).
remover_usuario(IdUsuario, [Usuario|Resto], [Usuario|NovaLista]) :-
    (IdEncontrado|_) = Usuario,
    IdUsuario \== IdEncontrado,
    remover_usuario(IdUsuario, Resto, NovaLista).
remover_usuario(IdUsuario, [Usuario|Resto], Resto) :-
    (IdEncontrado|_) = Usuario,
    IdUsuario = IdEncontrado,
    remover_usuario(IdUsuario, Resto, Resto).

sobrescrever(_, []).
sobrescrever(Arquivo, [Linha|Resto]) :-
    write(Arquivo, Linha),
    write(Arquivo, " .\n"),
    sobrescrever(Arquivo, Resto).