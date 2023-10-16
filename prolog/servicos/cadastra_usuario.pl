:- module(cadastra_usuario, [cadastra_usuario/1]).

:- use_module(models/usuario).

cadastra_usuario(Usuario):-
    open("dados/usuarios.txt", append, Fluxo),
    write(Fluxo, Usuario), write(Fluxo, ".\n"), nl,
    close(Fluxo),
    usuario_get_nome(Usuario, NomeUsuario),
    atomic_list_concat(["dados/alimentos/alimentos_", NomeUsuario, ".txt"], NomeArquivoAlimentos),
    open(NomeArquivoAlimentos, write, StreamAlimentos),
    close(StreamAlimentos).