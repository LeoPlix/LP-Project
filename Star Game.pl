% ist1113396 - Leonor Costa Guedes
:- use_module(library(clpfd)). % para poder usar transpose/2
:- set_prolog_flag(answer_write_options,[max_depth(0)]). % ver listas completas
:- [puzzles]. % Ficheiro dado. A avaliação terá mais puzzles.
:- [codigoAuxiliar]. % Ficheiro dado. Não alterar.

visualiza([]).
visualiza([H|T]) :-
/* 
    Dado um tabuleiro, visualiza-o no ecrã, ao que cada linha do tabuleiro é visualizada 
    numa linha diferente do ecrã.
    -----------------------------------------------
    Argumentos:
    Tabuleiro - Lista de listas de elementos, em que cada lista representa uma linha do tabuleiro.
*/

    writeln(H),
    visualiza(T).

visualizaLinha(L) :-
/*
    Dada uma linha do tabuleiro, visualiza-a no ecrã, onde cada elemento da linha é visualizado 
    numa linha diferente do ecrã com o número da coluna a que pertence.
    -----------------------------------------------
    Argumentos:
    L - Lista de elementos, onde cada elemento representa uma coluna da linha do tabuleiro.
*/

    visualizaLinha(L, 1).

visualizaLinha([], _).
visualizaLinha([H|T], N) :-
    write(N),
    write(': '),
    writeln(H), % Escreve o elemento da coluna e muda de linha
    N1 is N + 1,  % Incrementa o número da coluna
    visualizaLinha(T, N1).

insereObjecto((L,C), Tabuleiro, Obj) :-
/*
    Dada uma coordenada (L,C) e um tabuleiro, insere o objecto Obj na coordenada (L,C) do tabuleiro.
    -----------------------------------------------
    Predicado auxiliar:
        • limites/3 - Verifica se a coordenada (L,C) é válida para o tabuleiro.
            Argumentos: L - Número da linha.
                        C - Número da coluna.
                        Tabuleiro - Lista de listas de elementos, em que cada lista representa uma linha do tabuleiro.
    -----------------------------------------------
    Argumentos:
    (L,C) - Coordenada da posição a inserir o objecto.
    Tabuleiro - Lista de listas de elementos, em que cada lista representa uma linha do tabuleiro.
    Obj - Objecto a inserir na coordenada (L,C) do tabuleiro.
*/
    tabuleiro_valido(Tabuleiro),
    limites(L, C, Tabuleiro),
    !,
    nth1(L, Tabuleiro, Linha),
    nth1(C, Linha, Elem),
    ( var(Elem) -> Elem = Obj ; true ). % Se a coordenada for uma variável, insere o objecto Obj. 

insereObjecto((L,C), Tabuleiro, _) :-
    % Para a eventualidade de se tentar inserir um objecto numa coordenada que já não é válida.
    tabuleiro_valido(Tabuleiro),
    limites(L, C, Tabuleiro),
    nth1(L, Tabuleiro, Linha),
    nth1(C, Linha, Elem),
    \+ var(Elem),
    !.

insereObjecto((L,C), Tabuleiro, _) :-
    % Para a eventualidade de se tentar inserir um objecto numa coordenada que não é válida.
    tabuleiro_valido(Tabuleiro),
    \+ limites(L, C, Tabuleiro),
    !.

limites(L, C, Tabuleiro) :-
    length(Tabuleiro, NumLinhas),  % Verifica o número de linhas do tabuleiro
    NumLinhas > 0,
    nth1(1, Tabuleiro, Linha),
    length(Linha, NumColunas), % Verifica o número de colunas do tabuleiro
    L > 0, L =< NumLinhas, % Verifica se L é válido
    C > 0, C =< NumColunas. % Verifica se C é válido

tabuleiro_valido(Tabuleiro) :-
/*
    Verifica se o tabuleiro é válido, ou seja, se é uma lista de listas de elementos, 
    em que cada lista representa uma linha do tabuleiro.
    Predicado auxiliar que deve ser usado como verificação inicial em todos os predicados que usem o Tabuleiro.
    -----------------------------------------------
    Argumentos:
    Tabuleiro - Lista de listas de elementos, em que cada lista representa uma linha do tabuleiro.
*/
    is_list(Tabuleiro), 
    length(Tabuleiro, NumLinhas),
    NumLinhas > 0.

insereVariosObjectos([], _, []).
insereVariosObjectos([(L,C)|T], Tabuleiro, [H|R]) :-
/*
    Dada uma lista de coordenadas e um tabuleiro, insere o objecto p em todas as 
    coordenadas da lista no tabuleiro.
    -----------------------------------------------
    Argumentos:
    ListaCoords - Lista de coordenadas a inserir o objecto p.
    Tabuleiro - Lista de listas de elementos, em que cada lista representa uma linha do tabuleiro.
    TabuleiroFinal - Tabuleiro com os objectos p inseridos nas coordenadas da ListaCoords.
*/
    tabuleiro_valido(Tabuleiro),
    insereObjecto((L,C), Tabuleiro, H), !,
    insereVariosObjectos(T, Tabuleiro, R).

inserePontosVolta(Tabuleiro, (L,C)) :-
/*
    Dada uma coordenada (L,C) e um tabuleiro, insere o objecto p em todas as coordenadas 
    adjacentes a (L,C) no tabuleiro.
    -----------------------------------------------
    Argumentos:
    (L,C) - Coordenada a partir da qual se inserem os pontos.
    Tabuleiro - Lista de listas de elementos, onde cada lista representa uma linha do tabuleiro.
*/
    tabuleiro_valido(Tabuleiro),
    L1 is L - 1, % Coordenada acima
    L2 is L + 1, % Coordenada abaixo
    C1 is C - 1, % Coordenada à esquerda
    C2 is C + 1, % Coordenada à direita
    Coordenadas = [(L1, C1), (L1, C), (L1, C2), (L, C1), (L, C2), (L2, C1), (L2, C), (L2, C2)],
    inserePontos(Tabuleiro, Coordenadas),
    !.

inserePontos(_, []).
inserePontos(Tabuleiro, [(L,C)|T]) :-
/*
    Dada uma lista de coordenadas e um tabuleiro, insere o objecto p em todas as coordenadas em volta
    das coordenadas fornecidas.
    -----------------------------------------------
    Argumentos:
    ListaCoords - Lista de coordenadas a inserir o objecto p.
    Tabuleiro - Lista de listas de elementos, onde cada lista representa uma linha do tabuleiro.
    TabuleiroFinal - Tabuleiro com os objectos p inseridos nas coordenadas da ListaCoords.
*/
    tabuleiro_valido(Tabuleiro),
    insereObjecto((L,C), Tabuleiro, p), !, 
    inserePontos(Tabuleiro, T), % Chama recursivamente para as restantes coordenadas
    !.

objectosEmCoordenadas([], _, []).
objectosEmCoordenadas([(L,C)|T], Tabuleiro, [H|R]) :-
/*
    Dada uma lista de coordenadas e um tabuleiro, devolve uma lista com os objectos nas coordenadas 
    fornecidas.
    -----------------------------------------------
    Argumentos:
    ListaCoords - Lista de coordenadas a procurar os objectos.
    Tabuleiro - Lista de listas de elementos, onde cada lista representa uma linha do tabuleiro.
    ListaCoordObjs - Lista com os objectos nas coordenadas da ListaCoords.
*/
    limites(L, C, Tabuleiro),
    nth1(L, Tabuleiro, Linha),
    nth1(C, Linha, H), !,
    objectosEmCoordenadas(T, Tabuleiro, R). %Chama recursivamente para as restantes coordenadas

coordObjectos(Objecto, Tabuleiro, ListaCoords, ListaCoordObjs, NumObjectos) :-
/*
    Dado um objecto e um tabuleiro, devolve o número de objectos do tipo Objecto nas coordenadas 
    fornecidas.
    -----------------------------------------------
    Argumentos:
    Objecto - Objecto a procurar nas coordenadas (pode ser uma variável).
    Tabuleiro - Lista de listas de elementos, em que cada lista representa uma linha do tabuleiro.
    ListaCoords - Lista de coordenadas a procurar os objectos.
    ListaCoordObjs - Lista com os objectos nas coordenadas da ListaCoords.
    NumObjectos - Número de objectos do tipo Objecto nas coordenadas da ListaCoords.
*/
    tabuleiro_valido(Tabuleiro),
    objectosEmCoordenadas(ListaCoords, Tabuleiro, ListaObjs),
    ( var(Objecto) ->
        % Se Objecto é uma variável, inclui todas as coordenadas com elementos que se enquandrem na condição
        findall((L,C), 
                (nth1(Indice, ListaObjs, Elem),
                var(Elem),
                nth1(Indice, ListaCoords, (L,C))), 
                ListaCoordObjsDesordenada)
    ; 
        % Se Objecto não é uma variável, inclui apenas as coordenadas com o Objecto especificado
        findall((L,C), 
                (nth1(Indice, ListaObjs, Elem),
                Elem == Objecto,
                nth1(Indice, ListaCoords, (L,C))), 
                ListaCoordObjsDesordenada)
    ),
    sort(ListaCoordObjsDesordenada, ListaCoordObjs), % Ordena a lista de coordenadas
    length(ListaCoordObjs, NumObjectos). % Calcula o número de objectos do tipo Objecto nas coordenadas fornecidas
  
coordenadasVars(Tabuleiro, ListaVars):-
/*
    Dado um tabuleiro, devolve uma lista com as coordenadas das variáveis do tabuleiro.
    -----------------------------------------------
    Argumentos:
    Tabuleiro - Lista de listas de elementos, onde cada lista representa uma linha do tabuleiro.
    ListaVars - Lista com as coordenadas das variáveis do tabuleiro.
*/
    findall((L,C), 
            (nth1(L, Tabuleiro, Linha), 
            nth1(C, Linha, Elem), 
            var(Elem)), 
            ListaVarsDesordenada), !,
    sort(ListaVarsDesordenada, ListaVars).

fechaListaCoordenadas(Tabuleiro, ListaCoords) :-
/* 
    Dada uma lista de coordenadas e um tabuleiro, insere estrelas e pontos conforme necessário
    para fechar as coordenadas no tabuleiro.
    Comportamento:
        h1: Se a linha, coluna ou região associada à lista de coordenadas tiver 2 estrelas, ~
            enche as restantes coordenadas de pontos.
        h2: Se a linha, coluna ou região associada à lista de coordenadas tiver 1 estrela e 1 posição livre, 
            insere uma estrela na posição livre e insere pontos ao redor da estrela.
        h3: Se a linha, coluna ou região associada à lista de coordenadas não tiver estrelas e tiver 2 posições livres, 
            insere uma estrela em cada posição livre e insere pontos ao redor de cada estrela inserida.
            Se nenhuma das hipóteses se verificar, o tabuleiro mantém-se inalterável.
    -----------------------------------------------
    Argumentos:
    Tabuleiro - Lista de listas de elementos, em que cada lista representa uma linha do tabuleiro.
    ListaCoords - Lista de coordenadas a serem fechadas no tabuleiro.
*/ 
    tabuleiro_valido(Tabuleiro),
    coordObjectos(e, Tabuleiro, ListaCoords, _, NumEstrelas), !, % Conta as estrelas nas coordenadas fornecidas
    coordenadasVars(Tabuleiro, ListaVars), % Obtém as coordenadas das variáveis no tabuleiro
    intersection(ListaCoords, ListaVars, ListaCoordsLivres), !, % Obtém as variáveis nas coordenadas fornecidas
    length(ListaCoordsLivres, NumLivres), % Conta o número de coordenadas livres
    ( NumEstrelas == 2 ->
        % h1: 2 estrelas, enche as restantes coordenadas de pontos
        inserePontos(Tabuleiro, ListaCoordsLivres)
    ; NumEstrelas == 1, NumLivres == 1 ->
        % h2: 1 estrela e 1 posição livre, insere uma estrela e pontos ao redor
        nth1(1, ListaCoordsLivres, (L1, C1)),
        insereObjecto((L1, C1), Tabuleiro, e),
        inserePontosVolta(Tabuleiro, (L1, C1))
    ; NumEstrelas == 0, NumLivres == 2 ->
        % h3: nenhuma estrela e 2 posições livres, insere duas estrelas e pontos ao redor
        nth1(1, ListaCoordsLivres, (L1, C1)),
        nth1(2, ListaCoordsLivres, (L2, C2)),
        insereObjecto((L1, C1), Tabuleiro, e),
        insereObjecto((L2, C2), Tabuleiro, e),
        inserePontosVolta(Tabuleiro, (L1, C1)),
        inserePontosVolta(Tabuleiro, (L2, C2))
    ; % Caso nenhuma das hipóteses seja atendida, não faz nada
        true
    ).

fecha(Tabuleiro, ListaListasCoord) :-
/*
    Dada uma lista de listas (linhas, colunas ou regiões), aplica o predicado fechaListaCoordenadas/2
    a cada lista de coordenadas.
    -----------------------------------------------
    Argumentos:
    Tabuleiro - Lista de listas de elementos, onde cada lista representa uma linha do tabuleiro.
    ListaListasCoord - Lista de listas de coordenadas (linhas, colunas ou regiões).
*/
    maplist(fechaListaCoordenadas(Tabuleiro), ListaListasCoord). 
    % Aplica fechaListaCoordenadas/2 a cada lista de coordenadas

encontraSequencia(Tabuleiro, N, ListaCoords, Seq) :-
/*
    Encontra uma sublista de tamanho N em ListaCoords que verifica certas condições:
        • As coordenadas representam posições com variáveis.
        • As coordenadas aparecem seguidas (numa linha, coluna ou região).
        • Seq pode ser concatenada com duas listas, uma antes e uma depois, eventualmente vazias ou 
          com pontos nas coordenadas respectivas, permitindo obter ListaCoords.
        • Se houver mais variáveis na sequência que N, o predicado deve falhar.
    -----------------------------------------------
    Predicados auxiliares:
        • varCoord/2 - Verifica se a coordenada é uma variável.
            Argumentos: Tabuleiro - Lista de listas de elementos, onde cada lista representa uma linha do tabuleiro.
                        Coordenada - Coordenada a verificar.
        • consecutiva/2 - Verifica se as coordenadas são consecutivas.
            Argumentos: Lista - Lista de coordenadas.
                        Sub - Sublista de Lista.
    -----------------------------------------------
    Argumentos:
    Tabuleiro - Lista de listas de elementos, onde cada lista representa uma linha do tabuleiro.
    N - Tamanho da sequência Seq.
    ListaCoords - Lista de coordenadas.
    Seq - Sublista de ListaCoords.
*/
    coordObjectos(e, Tabuleiro, ListaCoords, _, 0), % Conta o número de estrelas nas coordenadas fornecidas  
    include(varCoord(Tabuleiro), ListaCoords, Seq), % Filtra as coordenadas que são variáveis
    consecutiva(ListaCoords, Seq), % Verifica se as coordenadas são consecutivas
    length(Seq, N), !. % Verifica se o tamanho da sequência é N

consecutiva(Lista, Sub) :- 
    % Verifica se a lista Sub é uma sublista consecutiva de Lista.
    append(_, Resto, Lista), 
    append(Sub, _, Resto).   

varCoord(Tabuleiro, (L, C)) :-
    nth1(L, Tabuleiro, Linha),
    nth1(C, Linha, Elem),
    var(Elem). % Verifica se a coordenada é uma variável

aplicaPadraoI(Tabuleiro, [(L1, C1), _, (L3, C3)]) :-
/*
    Aplica o padrão I no tabuleiro, que consiste em colocar uma estrela (e) em (L1, C1) e 
    (L3, C3) e insere os pontos (p) obrigatórios ao redor de cada estrela.
    -----------------------------------------------
    Argumentos:
    Tabuleiro - Lista de listas de elementos, onde cada lista representa uma linha do tabuleiro.
    [(L1, C1), (L2, C2), (L3, C3)] - Lista de coordenadas.
*/
    insereObjecto((L1, C1), Tabuleiro, e),
    insereObjecto((L3, C3), Tabuleiro, e),
    inserePontosVolta(Tabuleiro, (L1, C1)),
    inserePontosVolta(Tabuleiro, (L3, C3)).


aplicaPadroes(_, []). 
aplicaPadroes(Tabuleiro, [ListaCoords | Resto]) :-
/*
    Dada uma lista de listas de coordenadas, aplica os padrões I e T ao tabuleiro.
    -----------------------------------------------
    Argumentos:
    Tabuleiro - Lista de listas de elementos, onde cada lista representa uma linha do tabuleiro.
    ListaCoords - Lista de coordenadas.
*/
    (   % Se encontrar uma sequência de 3 variáveis consecutivas, aplica o padrão I
        encontraSequencia(Tabuleiro, 3, ListaCoords, Seq) -> aplicaPadraoI(Tabuleiro, Seq)
    ;   % Se encontrar uma sequência de 4 variáveis consecutivas, aplica o padrão T
        encontraSequencia(Tabuleiro, 4, ListaCoords, Seq) -> (aplicaPadraoT(Tabuleiro, Seq); true)
    ;
        true  % Se não encontrar nenhuma sequência, não faz nada
    ),
    aplicaPadroes(Tabuleiro, Resto). % Chama recursivamente para a próxima lista de coordenadas

resolve(Estruturas, Tabuleiro) :-
/* 
    Aplica os predicados aplicaPadroes/2 e fecha/2 repetidamente até que não haja mais alterações no tabuleiro.
    Se as variáveis mudarem após a aplicação dos padrões e fechamento, o loop continua; caso contrário, termina.
    -----------------------------------------------
    Predicados auxiliares:
        • loop/2 - Aplica padrões e fecha o tabuleiro repetidamente até que não haja mais mudanças.
            Argumentos: Tabuleiro - Lista de listas de elementos, onde cada lista representa uma linha do tabuleiro.
                        CoordTodas - Lista de listas de todas as coordenadas (linhas, colunas ou regiões).
    -----------------------------------------------
    Argumentos:
    Estruturas - Estrutura contendo as linhas, colunas ou regiões do tabuleiro.
    Tabuleiro - Lista de listas de elementos, onde cada lista representa uma linha do tabuleiro.
*/
    tabuleiro_valido(Tabuleiro),
    coordTodas(Estruturas, CoordTodas), % Obtém todas as coordenadas das estruturas (linhas, colunas e regiões)
    loop(Tabuleiro, CoordTodas), !. % Executa o predicado loop até estabilizar

loop(Tabuleiro, CoordTodas) :-
    coordenadasVars(Tabuleiro, VarsAntes), % Captura as variáveis antes de aplicar os padrões
    aplicaPadroes(Tabuleiro, CoordTodas), % Aplica os padrões
    fecha(Tabuleiro, CoordTodas), % Fecha o tabuleiro
    coordenadasVars(Tabuleiro, VarsDepois), % Captura as variáveis depois de aplicar os padrões
    (
        VarsAntes \= VarsDepois -> 
        loop(Tabuleiro, CoordTodas)  %Se houver mudanças, chama recursivamente
    ;
        true % Se não houver mudanças, termina o loop
    ).
