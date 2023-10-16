:- use_module(servicos/lista_usuarios).
:- use_module(servicos/pega_usuario_por_id).
:- use_module(servicos/deleta_usuario_por_id).
:- use_module(servicos/altera_usuario_por_id).
:- use_module(servicos/patch_usuario).
:- use_module(servicos/cadastra_usuario).
:- use_module(models/usuario).

main():-
    deleta_usuario_por_id(442),
    halt.