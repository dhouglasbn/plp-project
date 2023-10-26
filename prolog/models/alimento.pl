:- module(alimento, [
	alimento/8,
	alimento_set_quantidade/4
	]).

alimento(ID, Nome, Kcal, Proteinas, Gorduras, Carboidratos, Quantidade, IDRefeicao):-
	string_lower(Nome, NomeMinusculo),
	Alimento = (ID|NomeMinusculo|Kcal|Proteinas|Gorduras|
		Carboidratos|Quantidade|0).

alimento_set_quantidade(Alimento, Quantidade, IDRefeicao,  NovoAlimento):-
	(A|B|Kcal|Prot|Gord|Carbo|Dados|_) = Alimento,
	NovaKcal is Kcal * Quantidade / 100,
	NovaProt is Prot * Quantidade / 100,
	NovaGord is Gord * Quantidade / 100,
	NovoCarbo is Carbo * Quantidade / 100,
	NovoAlimento = (A|B|NovaKcal|NovaProt|NovaGord|NovoCarbo
		|Quantidade|IDRefeicao).
