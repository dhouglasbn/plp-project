:- module(usuario, [
    usuario/8,
    usuario/10,
    usuario/16,
    usuario_get_senha/2,
    usuario_get_nome/2,
    usuario_get_genero/2,
    usuario_get_idade/2,
    usuario_get_peso/2,
    usuario_get_altura/2,
    usuario_get_meta_peso/2,
    usuario_get_meta_kcal/2,
    usuario_get_kcal_atual/2
    ]).

usuario(Senha, Nome, Genero, Idade, Peso, Altura, MetaPeso, Usuario):-
    string_lower(Nome, NomeMinusculo),
    quebrar_e_substituir(NomeMinusculo, NomeFormatado),
    Usuario = (Senha|NomeFormatado|Genero|Idade|Peso|Altura|MetaPeso|0.0|0.0|[]|[]).

usuario(Senha, Nome, Genero, Idade, Peso, Altura, MetaPeso, MetaKcal, KcalAtual, Usuario):-
    string_lower(Nome, NomeMinusculo),
    quebrar_e_substituir(NomeMinusculo, NomeFormatado),
    Usuario = (Senha|NomeFormatado|Genero|Idade|Peso|Altura|MetaPeso|MetaKcal|KcalAtual|[]|[]).

usuario(Senha, Nome, Genero, Idade, Peso, Altura, MetaPeso, MetaKcal, 
KcalAtual, ExerciciosAerobicos, ExerciciosAnaerobicos, Usuario):-
    string_lower(Nome, NomeMinusculo),
    quebrar_e_substituir(NomeMinusculo, NomeFormatado),
    Usuario = (Senha|NomeFormatado|Genero|Idade|Peso|Altura|MetaPeso|MetaKcal|
    KcalAtual|ExerciciosAerobicos|ExerciciosAnaerobicos).

usuario_get_senha(Usuario, Senha):-
    (Senha|_) = Usuario.

usuario_get_nome(Usuario, Nome):-
    (_|Nome|_) = Usuario.

usuario_get_genero(Usuario, Genero):-
    (_|_|Genero|_) = Usuario.

usuario_get_idade(Usuario, Idade):-
    (_|_|_|Idade|_) = Usuario.

usuario_get_peso(Usuario, Peso):-
    (_|_|_|_|Peso|_) = Usuario.

usuario_get_altura(Usuario, Altura):-
    (_|_|_|_|_|Altura|_) = Usuario.

usuario_get_meta_peso(Usuario, MetaPeso):-
    (_|_|_|_|_|_|MetaPeso|_) = Usuario.

usuario_get_meta_kcal(Usuario, MetaKcal):-
    (_|_|_|_|_|_|_|MetaKcal|_) = Usuario.

usuario_get_kcal_atual(Usuario, KcalAtual):-
    (_|_|_|_|_|_|_|_|KcalAtual|_) = Usuario.

quebrar_e_substituir(String, Resultado) :-
    atomic_list_concat(Palavras, ' ', String),
    atomic_list_concat(Palavras, '_', Resultado).