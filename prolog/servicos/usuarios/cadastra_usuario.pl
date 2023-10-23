:- module(cadastra_usuario, [cadastra_usuario/1]).

:- use_module(models/usuario).

cadastra_usuario(Usuario):-
    open("dados/usuarios.txt", append, Fluxo),
    write(Fluxo, Usuario), write(Fluxo, ".\n"), nl,
    close(Fluxo),
    usuario_get_nome(Usuario, NomeUsuario),
    atomic_list_concat(["dados/alimentos/alimentos_", NomeUsuario, ".txt"], NomeArquivoAlimentos),
    atomic_list_concat(["dados/exercicios_aerobicos_users/aerobicos_", NomeUsuario, ".txt"], NomeArquivoAerobicos),
    atomic_list_concat(["dados/exercicios_anaerobicos_users/anaerobicos_", NomeUsuario, ".txt"], NomeArquivoAnaerobicos),
    open(NomeArquivoAlimentos, write, StreamAlimentos),
    open(NomeArquivoAerobicos, write, StreamAerobicos),
    open(NomeArquivoAnaerobicos, write, StreamAnaerobicos),
    close(StreamAlimentos),
    close(StreamAerobicos),
    close(StreamAnaerobicos).