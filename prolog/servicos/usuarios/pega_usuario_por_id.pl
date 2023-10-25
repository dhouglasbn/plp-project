:- module(pega_usuario_por_id, [pega_usuario_por_id/2]).

:- use_module(lista_usuarios).

pega_usuario_por_id(Id, Usuario):-
    lista_usuarios(Lista),
    consulta_usuario(Id, Lista, Usuario).

consulta_usuario(_, [], "NOUSER").
consulta_usuario(IdDesejado, [UsuarioHead|_], UsuarioHead):-
    (IdEncontrado|_) = UsuarioHead,
    IdEncontrado = IdDesejado, !.
consulta_usuario(IdDesejado, [_|Tail], Usuario):-
    consulta_usuario(IdDesejado, Tail, Usuario).
