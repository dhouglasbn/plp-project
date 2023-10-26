:- module(usuario, [
    usuario/8,
    usuario/10,
    usuario_get_senha/2,
    usuario_get_nome/2,
    usuario_get_genero/2,
    usuario_get_idade/2,
    usuario_get_peso/2,
    usuario_get_altura/2,
    usuario_get_meta_peso/2,
    usuario_get_meta_kcal/2,
    usuario_get_kcal_atual/2,
    usuario_set_senha/3,
    usuario_set_nome/3,
    usuario_set_genero/3,
    usuario_set_idade/3,
    usuario_set_peso/3,
    usuario_set_altura/3,
    usuario_set_meta_peso/3,
    usuario_set_meta_kcal/3,
    usuario_set_kcal_atual/3,
    quebrar_e_substituir/2
    ]).

usuario(Senha, Nome, Genero, Idade, Peso, Altura, MetaPeso, Usuario):-
    string_lower(Nome, NomeMinusculo),
    string_lower(Genero, GeneroMinusculo),
    quebrar_e_substituir(NomeMinusculo, NomeFormatado),
    Usuario = (Senha|NomeFormatado|GeneroMinusculo|Idade|Peso|Altura|MetaPeso|0.0|0.0).

usuario(Senha, Nome, Genero, Idade, Peso, Altura, MetaPeso, MetaKcal, KcalAtual, Usuario):-
    string_lower(Nome, NomeMinusculo),
    string_lower(Genero, GeneroMinusculo),
    quebrar_e_substituir(NomeMinusculo, NomeFormatado),
    Usuario = (Senha|NomeFormatado|GeneroMinusculo|Idade|Peso|Altura|MetaPeso|MetaKcal|KcalAtual).
    
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
    (_|_|_|_|_|_|_|_|KcalAtual) = Usuario.

usuario_set_senha(Usuario, Senha, NovoUsuario):-
    (_|Dados) = Usuario,
    NovoUsuario = (Senha|Dados).

usuario_set_nome(Usuario, Nome, NovoUsuario):-
    string_lower(Nome, NomeMinusculo),
    quebrar_e_substituir(NomeMinusculo, NomeFormatado),
    (A|_|Dados) = Usuario,
    NovoUsuario = (A|NomeFormatado|Dados).

usuario_set_genero(Usuario, Genero, NovoUsuario):-
    string_lower(Genero, GeneroMinusculo),
    (A|B|_|Dados) = Usuario,
    NovoUsuario = (A|B|GeneroMinusculo|Dados).

usuario_set_idade(Usuario, Idade, NovoUsuario):-
    (A|B|C|_|Dados) = Usuario,
    NovoUsuario = (A|B|C|Idade|Dados).

usuario_set_peso(Usuario, Peso, NovoUsuario):-
    (A|B|C|D|_|Dados) = Usuario,
    NovoUsuario = (A|B|C|D|Peso|Dados).

usuario_set_altura(Usuario, Altura, NovoUsuario):-
    (A|B|C|D|E|_|Dados) = Usuario,
    NovoUsuario = (A|B|C|D|E|Altura|Dados).

usuario_set_meta_peso(Usuario, MetaPeso, NovoUsuario):-
    (A|B|C|D|E|F|_|Dados) = Usuario,
    NovoUsuario = (A|B|C|D|E|F|MetaPeso|Dados).

usuario_set_meta_kcal(Usuario, MetaKcal, NovoUsuario):-
    (A|B|C|D|E|F|G|_|Dados) = Usuario,
    NovoUsuario = (A|B|C|D|E|F|G|MetaKcal|Dados).

usuario_set_kcal_atual(Usuario, KcalAtual, NovoUsuario):-
    (A|B|C|D|E|F|G|H|_) = Usuario,
    NovoUsuario = (A|B|C|D|E|F|G|H|KcalAtual).

quebrar_e_substituir(String, Resultado) :-
    atomic_list_concat(Palavras, ' ', String),
    atomic_list_concat(Palavras, '_', Resultado).