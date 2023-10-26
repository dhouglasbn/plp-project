:- module(pegar_alimento_por_id, [pegar_alimento_por_id/2]).

:- use_module(listar_alimentos).

pegar_alimento_por_id(Id, Alimento):-
    listar_alimentos(Lista),
    consulta_alimento(Id, Lista, Alimento).

consulta_alimento(_, [], "NOALIMENTO").
consulta_alimento(IdDesejado, [AlimentoHead|_], AlimentoHead):-
    (IdEncontrado|_) = AlimentoHead,
    IdEncontrado = IdDesejado, !.
consulta_alimento(IdDesejado, [_|Tail], Alimento):-
    consulta_alimento(IdDesejado, Tail, Alimento).
