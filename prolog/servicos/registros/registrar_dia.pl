:- module(registar_dia, [registrar_dia/2, verifica_dia_atual/2]).


registrar_dia(Data, NomeUsuario):-
    absolute_file_name("users/", CaminhoAbsoluto),
    atomic_list_concat([CaminhoAbsoluto, NomeUsuario, "/"], PastaUsuario),
    registrar_lista(Data, PastaUsuario).

registrar_lista(Data, CaminhoAbsoluto):-
    atomic_list_concat([CaminhoAbsoluto, Data, "/"], PastaData),
    make_directory(PastaData),
    atomic_list_concat([PastaData, "/alimento.txt"], NomeArquivoAlimentos),
    atomic_list_concat([PastaData, "/aerobicos.txt"], NomeArquivoAerobicos),
    atomic_list_concat([PastaData, "/anaerobicos.txt"], NomeArquivoAnaerobicos),
    open(NomeArquivoAlimentos, write, StreamAlimentos),
    open(NomeArquivoAerobicos, write, StreamAerobicos),
    open(NomeArquivoAnaerobicos, write, StreamAnaerobicos),
    close(StreamAlimentos),
    close(StreamAerobicos),
    close(StreamAnaerobicos).

verifica_dia_atual(Data, NomeUsuario):-
    absolute_file_name("users/", CaminhoAbsoluto),
    atomic_list_concat([CaminhoAbsoluto, NomeUsuario, "/", Data, "/"], PastaData),
    exists_directory(PastaData).