:- module(cadastra_usuario, [cadastra_usuario/1]).

cadastra_usuario(Usuario):-
    open("usuarios.txt", append, Fluxo),
    write(Fluxo, Usuario), write(Fluxo, ".\n"), nl,
    close(Fluxo).