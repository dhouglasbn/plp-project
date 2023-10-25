:- module(cadastra_usuario, [cadastra_usuario/1]).

:- consult('../../models/usuario').

cadastra_usuario(Usuario):-
    open("dados/usuarios.txt", append, Fluxo),
    write(Fluxo, Usuario), write(Fluxo, ".\n"), nl,
    close(Fluxo),
    usuario_get_nome(Usuario, NomeUsuario),
    registrar_user_diretorio(NomeUsuario).

registrar_user_diretorio(NomeUsuario):-
    absolute_file_name("users/", CaminhoAbsoluto),
    atomic_list_concat([CaminhoAbsoluto, NomeUsuario, "/"], PastaUsuario),
    make_directory(PastaUsuario),
    criar_registros_exercicios(PastaUsuario).

criar_registros_exercicios(PastaUsuario):-
    atomic_list_concat([PastaUsuario, "todos-exercicios.txt"], TodosExercicios),
    open(TodosExercicios, write, StreamTodosExercicios),
    close(StreamTodosExercicios).
