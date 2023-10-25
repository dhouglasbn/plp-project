:- module(listar_alimentos_do_dia, [listar_alimentos_do_dia/3]).
:- use_module(listar_alimentos).

listar_alimentos_do_dia(NomeUsuario, Data, Lista):-
	absolute_file_name("users/", CaminhoAbsoluto),
	atomic_list_concat([CaminhoAbsoluto, NomeUsuario, "/",  Data, "/"], PastaUsuario),
	(exists_directory(PastaUsuario) ->
		atomic_list_concat([PastaUsuario, "alimento.txt"], Arquivo),
		listar_alimentos(Arquivo, Lista);
		write("A pasta nao existe.")).
