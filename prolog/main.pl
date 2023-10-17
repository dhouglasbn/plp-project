:- use_module(servicos/lista_usuarios).
:- use_module(servicos/pega_usuario_por_id).
:- use_module(servicos/deleta_usuario_por_id).
:- use_module(servicos/altera_usuario_por_id).
:- use_module(servicos/patch_usuario).
:- use_module(servicos/cadastra_usuario).
:- use_module(models/usuario).

main():-
    usuario(443,"user teste5","t",15,120.0,1.6,100.0, Usuario),
    altera_usuario_por_id(443, Usuario),
    halt.