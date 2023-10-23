:- module(deleta_usuario_por_id, [deleta_usuario_por_id/1]).

:- use_module(lista_usuarios).
:- use_module(pega_usuario_por_id).
:- use_module(models/usuario).

deleta_usuario_por_id(Id):-
    deletar_arquivo_alimentos(Id),
    lista_usuarios(Lista),
    remover_usuario(Id, Lista, NovaLista),
    open("dados/usuarios.txt", write, Fluxo),
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

deletar_arquivo_alimentos(Id):-
    pega_usuario_por_id(Id, Usuario),
    usuario_get_nome(Usuario, NomeUsuario),
    atomic_list_concat(['dados/alimentos/alimentos_', NomeUsuario, '.txt'], NomeArquivo),
    delete_file(NomeArquivo).

sobrescrever(_, []).
sobrescrever(Arquivo, [Linha|Resto]) :-
    write(Arquivo, Linha),
    write(Arquivo, " .\n"),
    sobrescrever(Arquivo, Resto).