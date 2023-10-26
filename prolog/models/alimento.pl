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
	NovaKcal = Kcal * Quantidade,
	NovaProt = Prot * Quantidade,
	NovaGord = Gord * Quantidade,
	NovoCarbo = Carbo * Quantidade,
	NovoAlimento = (A|B|NovaKcal|NovaProt|NovaGord|NovoCarbo
		|Quantidade|IDRefeicao).
