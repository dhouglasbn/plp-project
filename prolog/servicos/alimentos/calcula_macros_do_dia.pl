:- module(calcula_macros_do_dia,
	[calcula_macros_do_dia/3,
		calcula_calorias_do_dia/2,
		calcula_proteinas_do_dia/2,
		calcula_carboidratos_do_dia/2,
		calcula_gorduras_do_dia/2,
		get_kcal/2,
		get_proteina/2,
		get_gordura/2,
		get_carbo/2]).

:- use_module(listar_alimentos_do_dia).

calcula_macros_do_dia(NomeUsuario, Data, (Kcal|Proteina|Gordura|Carboidrato)):-
	listar_alimentos_do_dia(NomeUsuario, Data, Lista),
	calcula_calorias_do_dia(Lista, Kcal),
	calcula_proteinas_do_dia(Lista, Proteina),
	calcula_gorduras_do_dia(Lista, Gordura),
	calcula_carboidratos_do_dia(Lista, Carboidrato).

calcula_calorias_do_dia([], 0):-!.
calcula_calorias_do_dia([H|T], Soma):-
	calcula_calorias_do_dia(T, CaloriaAcumulada),
	get_kcal(H, CaloriaAtual),
	Soma is CaloriaAtual + CaloriaAcumulada.

calcula_proteinas_do_dia([], 0):-!.
calcula_proteinas_do_dia([H|T], Soma):-
	calcula_proteinas_do_dia(T, ProteinaAcumulada),
	get_proteina(H, ProteinaAtual),
	Soma is ProteinaAtual + ProteinaAcumulada.

calcula_gorduras_do_dia([], 0):-!.
calcula_gorduras_do_dia([H|T], Soma):-
	get_gordura(H, GorduraAtual),
	calcula_gorduras_do_dia(T, GorduraAcumulada),
	Soma is GorduraAtual + GorduraAcumulada.

calcula_carboidratos_do_dia([], 0):-!.
calcula_carboidratos_do_dia([H|T], Soma):-
	calcula_carboidratos_do_dia(T, CarboidratoAcumulado),
	get_carbo(H, CarboidratoAtual),
	Soma is CarboidratoAtual + CarboidratoAcumulado.

get_kcal(Alimento, Kcal):-
	(_|_|Kcal|_) = Alimento.
get_proteina(Alimento, Proteina):-
	(_|_|_|Proteina|_) = Alimento.
get_gordura(Alimento, Gordura):-
	(_|_|_|_|Gordura|_) = Alimento.
get_carbo(Alimento, Carbo):-
	(_|_|_|_|_|Carbo|_) = Alimento.
