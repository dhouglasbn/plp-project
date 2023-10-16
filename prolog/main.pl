:- use_module(servicos/lista_usuarios).
:- use_module(servicos/pega_usuario_por_id).
:- use_module(servicos/deleta_usuario_por_id).
:- use_module(servicos/altera_usuario_por_id).
:- use_module(servicos/patch_usuario).
:- use_module(servicos/cadastra_usuario).
:- use_module(models/usuario).

main():-
    usuario(442,"user teste3","t",15,120.0,1.6,100.0, Usuario),
    cadastra_usuario(Usuario),
    write(Usuario),
    halt.