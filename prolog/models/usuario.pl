:- module(usuario, [usuario/8, usuario/10, usuario/16]).

usuario(Senha, Nome, Genero, Idade, Peso, Altura, MetaPeso, Usuario):-
    string_lower(Nome, NomeMinusculo),
    quebrar_e_substituir(NomeMinusculo, NomeFormatado),
    Usuario = (Senha|NomeFormatado|Genero|Idade|Peso|Altura|MetaPeso|0.0|0.0|[]|[]|[]|[]|[]|[]).

usuario(Senha, Nome, Genero, Idade, Peso, Altura, MetaPeso, MetaKcal, KcalAtual, Usuario):-
    string_lower(Nome, NomeMinusculo),
    quebrar_e_substituir(NomeMinusculo, NomeFormatado),
    Usuario = (Senha|NomeFormatado|Genero|Idade|Peso|Altura|MetaPeso|MetaKcal|KcalAtual|[]|[]|[]|[]|[]|[]).

usuario(Senha, Nome, Genero, Idade, Peso, Altura, MetaPeso, MetaKcal, 
KcalAtual, ExerciciosAerobicos, ExerciciosAnaerobicos, Cafe, Almoco, Lanche, Janta, Usuario):-
    string_lower(Nome, NomeMinusculo),
    quebrar_e_substituir(NomeMinusculo, NomeFormatado),
    Usuario = (Senha|NomeFormatado|Genero|Idade|Peso|Altura|MetaPeso|MetaKcal|
    KcalAtual|ExerciciosAerobicos|ExerciciosAnaerobicos|Cafe|Almoco|Lanche|Janta).

quebrar_e_substituir(String, Resultado) :-
    atomic_list_concat(Palavras, ' ', String),
    atomic_list_concat(Palavras, '_', Resultado).