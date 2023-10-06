:- use_module(servicos/lista_usuarios).
:- use_module(servicos/pega_usuario_por_id).
:- use_module(servicos/deleta_usuario_por_id).
:- use_module(servicos/altera_usuario_por_id).
:- use_module(servicos/cadastra_usuario).
:- use_module(models/usuario).

main():-
    usuario(140,"caiozao_victor","m",21,60.0,1.7,60.0,0.0,0.0,[],[],[],[],[],[], Usuario),
    head(Usuario, Id),
    altera_usuario_por_id(Id, Usuario),
    halt.

head((H|_), H).