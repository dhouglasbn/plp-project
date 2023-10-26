module(alimento, [
	alimento/7,
	alimento_set_quantidade/3
	]).

alimento(ID, Nome, Kcal, Proteinas, Gorduras, Carboidratos, Quantidade):-
	string_lower(Nome, NomeMinusculo),
	Alimento = (ID|NomeMinusculo|Kcal|Proteinas|Gorduras|
		Carboidratos|Quantidade).

alimento_set_quantidade(Alimento, Quantidade, NovoAlimento):-
	(A|B|Kcal|Prot|Gord|Carbo|Dados|_) = Alimento,
	NovaKcal = Kcal * Quantidade,
	NovaProt = Prot * Quantidade,
	NovaGord = Gord * Quantidade,
	NovoCarbo = Carbo * Quantidade,
	NovoAlimento = (A|B|NovaKcal|NovaProt|NovaGord|NovoCarbo
		|Quantidade).
