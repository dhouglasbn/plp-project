:- module(registar_exercicio_anaerobico, [registar_exercicio_anaerobico/1]).

:- use_module(models/usuario).

registar_exercicio_anaerobico(Data, NomeExercicio, DuracaoTreino):-
    usuario_get_nome(Usuario, NomeUsuario),
    atomic_list_concat(["../../dados/exercicios_aerobicos_users/aerobicos_", NomeUsuario, ".txt"], NomeDoArquivoAerobicos),