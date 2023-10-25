:- module(pega_exercicio_por_id, [pega_exercicio_por_id/2]).

:- use_module(lista_exercicio).

pega_exercicio_por_id(Id, Exercicio):-
    lista_exercicio(Lista),
    consulta_exercicio(Id, Lista, Exercicio).

consulta_exercicio(IdCurrent, [ExercicioHead|_], ExercicioHead):-
    (IdEncontrado|_) = ExercicioHead,
    IdEncontrado = IdCurrent, !.

consulta_exercicio(IdCurrent, [_|Tail], Exercicio):-
    consulta_exercicio(IdCurrent, Tail, Exercicio).