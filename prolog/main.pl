main():-
    open('usuarios.txt', read, Fluxo),
    ler_usuarios(Fluxo, Linhas),
    close(Fluxo),
    write(Linhas), nl.


ler_usuarios(F, []):-
    at_end_of_stream(F).
ler_usuarios(F, [X|L]):-
    \+ at_end_of_stream(F),
    read(F, X),
    ler_usuarios(F, L).
