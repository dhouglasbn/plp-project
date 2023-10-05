:- module(usuario, [usuario/8, usuario/10, usuario/16]).

quebrar_e_substituir(String, Resultado) :-
    atomic_list_concat(Palavras, ' ', String),
    atomic_list_concat(Palavras, '_', Resultado).

usuario(Senha, Nome, Genero, Idade, Peso, Altura, MetaPeso, Usuario):-
    quebrar_e_substituir(Nome, NomeFormatado),
    Usuario = (Senha|NomeFormatado|Genero|Idade|Peso|Altura|MetaPeso|0.0|0.0|[]|[]|[]|[]|[]|[]).

usuario(Senha, Nome, Genero, Idade, Peso, Altura, MetaPeso, MetaKcal, KcalAtual, Usuario):-
    quebrar_e_substituir(Nome, NomeFormatado),
    Usuario = (Senha|NomeFormatado|Genero|Idade|Peso|Altura|MetaPeso|MetaKcal|KcalAtual|[]|[]|[]|[]|[]|[]).

usuario(Senha, Nome, Genero, Idade, Peso, Altura, MetaPeso, MetaKcal, 
KcalAtual, ExerciciosAerobicos, ExerciciosAnaerobicos, Cafe, Almoco, Lanche, Janta, Usuario):-
    quebrar_e_substituir(Nome, NomeFormatado),
    Usuario = (Senha|NomeFormatado|Genero|Idade|Peso|Altura|MetaPeso|MetaKcal|
    KcalAtual|ExerciciosAerobicos|ExerciciosAnaerobicos|Cafe|Almoco|Lanche|Janta).