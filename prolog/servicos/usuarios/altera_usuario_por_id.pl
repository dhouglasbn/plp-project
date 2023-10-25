:- module(altera_usuario_por_id, [altera_usuario_por_id/2]).

:- use_module(lista_usuarios).
:- use_module(models/usuario).
:- use_module(pega_usuario_por_id).

altera_usuario_por_id(Id, NovoUsuario):-
    pega_usuario_por_id(Id, VelhoUsuario),
    altera_arquivo_alimentos(VelhoUsuario, NovoUsuario),
    lista_usuarios(Lista),
    altera_usuario(Id, NovoUsuario, Lista, NovaLista),

    open("dados/usuarios.txt", write, Fluxo),
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

altera_arquivo_alimentos(VelhoUsuario, NovoUsuario):-
    usuario_get_nome(VelhoUsuario, VelhoNome),
    usuario_get_nome(NovoUsuario, NovoNome),
    (VelhoNome = NovoNome -> !
        ; atomic_list_concat(['dados/alimentos/alimentos_', VelhoNome, '.txt'], VelhoNomeArquivo),
    atomic_list_concat(['dados/alimentos/alimentos_', NovoNome, '.txt'], NovoNomeArquivo),
    rename_file(VelhoNomeArquivo, NovoNomeArquivo)).
    
    

sobrescrever(_, []).
sobrescrever(Arquivo, [Linha|Resto]) :-
    write(Arquivo, Linha),
    write(Arquivo, ".\n"),
    sobrescrever(Arquivo, Resto).