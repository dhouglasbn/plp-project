:- module(patch_usuario, [patch_usuario/2]).

:- use_module(lista_usuarios).

patch_usuario(SenhaAntiga, NovaSenha):-
    lista_usuarios(Lista),
    patch_usuario(SenhaAntiga, NovaSenha, Lista, NovaLista),
    open("usuarios.txt", write, Fluxo),
    sobrescrever(Fluxo, NovaLista),
    close(Fluxo).

patch_usuario(_, _, [], []).
patch_usuario(SenhaAntiga, NovaSenha, [Usuario|Resto], [Usuario|NovaLista]) :-
    (SenhaEncontrada|_) = Usuario,
    SenhaAntiga \== SenhaEncontrada,
    patch_usuario(SenhaAntiga, NovaSenha, Resto, NovaLista).
patch_usuario(SenhaAntiga, NovaSenha, [Usuario|Resto], NovaLista) :-
    (IdEncontrado|_) = Usuario,
    SenhaAntiga = IdEncontrado,
    (_|DadosUsuario) = Usuario,
    append([(NovaSenha|DadosUsuario)], Resto, NovaLista),
    patch_usuario(SenhaAntiga, NovaSenha, Resto, Resto).

sobrescrever(_, []).
sobrescrever(Arquivo, [Linha|Resto]) :-
    write(Arquivo, Linha),
    write(Arquivo, " .\n"),
    sobrescrever(Arquivo, Resto).