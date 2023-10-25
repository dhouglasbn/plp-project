:- module(cadastrar_exercicio_anaerobico, [cadastrar_exercicio_anaerobico/5]).

%calcular_perda_calorica_anaerobico(PesoUsuario, DuracaoTreino, PerdaCalorica):-
%    PerdaCalorica = (PesoUsuario * DuracaoTreino) * 4.


% Metodo só calcula o peso total de exercicios anaerobicos
%calcular_perda_calorica_total_por_dia(ListaExercicios, PesoUsuario, ValorTotal):-
%    ValorTotalCurrent is ValorTotal,
%    calcular_perda_calorica_total_por_dia()

cadastrar_exercicio_anaerobico(NomeUsuario, NomeExercicio, Duracao, PesoUsuario, Data):-
    absolute_file_name("users/", CaminhoAbsoluto),
    atomic_list_concat([CaminhoAbsoluto, NomeUsuario, "/", Data, "/anaerobicos.txt"], Caminho),
    Exercicio = (NomeExercicio|Duracao|PesoUsuario),
    open(Caminho, append, Fluxo),
    write(Fluxo, Exercicio), write(Fluxo, ".\n"), nl,
    close(Fluxo).