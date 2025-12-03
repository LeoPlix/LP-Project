Star Battle Solver em Prolog
Descrição do Projeto
Este projeto consiste na implementação de um resolvedor de puzzles Star Battle em Prolog, desenvolvido no âmbito da unidade curricular de Lógica para Programação (2024-2025).

O programa é capaz de:

Visualizar tabuleiros de jogo

Inserir estrelas (e) e pontos (p) respeitando as regras do jogo

Aplicar estratégias de resolução automática

Resolver puzzles completos ou parciais de Star Battle

Regras do Jogo Star Battle
Tabuleiro N×N dividido em regiões

Objetivo: Colocar 2 estrelas em cada linha, cada coluna e cada região

Restrição: Estrelas não podem ser vizinhas (nem ortogonalmente nem diagonalmente)

Marcação: Posições sem estrela recebem pontos (p)

Estrutura do Código
Predicados Principais
Visualização (visualiza/1, visualizalinha/1)

Inserção (insereObjecto/3, insereVariosObjectos/3, inserePontosVolta/2, inserePontos/2)

Consultas (objectosEmCoordenadas/3, coordObjectos/5, coordenadasVars/2)

Estratégias (fechalistaCoordenadas/2, fecha/2, encontraSequencia/4, aplicaPadraoI/2, aplicaPadroes/2)

Resolução Final (resolve/2)

Ficheiros Fornecidos
puzzles.pl: Conjunto de puzzles para teste

codigoAuxiliar.pl: Predicados auxiliares (não modificar)

Requisitos Técnicos
SWI-Prolog (versão compatível)

Módulo library(clpfd) para transpose/2

Configuração: set_prolog_flag(answer_write_options,[max_depth(0)])

Instalação e Execução
Clone o repositório

Carregue o ficheiro principal no SWI-Prolog:

prolog
?- [projecto].
Execute os puzzles de teste:

prolog
?- sol(9-2, Tab), resolve(E, Tab).
Estratégias Implementadas
1. Fechamento de Linhas/Colunas/Regiões
H1: 2 estrelas → preenche resto com pontos

H2: 1 estrela + 1 vaga → insere estrela

H3: 0 estrelas + 2 vagas → insere ambas

2. Padrões de Sequência
Padrão I (3 variáveis seguidas): Estrelas nas extremidades

Padrão T (4 variáveis seguidas): Aplicação específica
