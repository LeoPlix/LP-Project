# Star Battle Solver (Prolog)

A compact Star Battle puzzle solver implemented in Prolog for the "Logic for Programming" course (2024–2025). This project provides board visualization, rule-based insertion of stars and points, and automatic solving strategies capable of tackling full or partial Star Battle puzzles.

---

## Table of Contents

- Overview
- Features
- Star Battle rules (quick)
- Project structure & main predicates
- Provided files
- Requirements & configuration
- Installation & running
- Usage examples
- Implemented solving strategies
- Testing
- Contributing
- License & contact

---

## Overview

This repository implements a Star Battle solver using Prolog. The program models boards, enforces the rules of Star Battle, visualizes boards, and applies a set of deterministic strategies to progress toward or produce complete solutions. It is intended for learning logic programming techniques and constraint propagation in SWI-Prolog.

---

## Features

- Board visualization and line-by-line rendering
- Insert stars (e) and points (p) while maintaining game constraints
- Deterministic solving strategies (row/column/region closure, pattern recognition)
- Solve full puzzles or continue partially solved puzzles
- Test puzzles included for quick experimentation

---

## Star Battle — rules (short)

- Board: N × N grid partitioned into regions.
- Goal: Place exactly 2 stars in each row, each column, and each region.
- Restriction: Stars cannot be adjacent — not orthogonally nor diagonally.
- Marking: Any cell without a star is marked as a point (p).

---

## Project structure & main predicates

This section lists the most important predicates you will interact with. Exact implementations are in the sources.

- Visualization
  - visualiza/1 — render a whole board
  - visualizalinha/1 — render a single row
- Insertion & marking
  - insereObjecto/3 — insert an object (star/point) at a coordinate
  - insereVariosObjectos/3 — insert multiple objects
  - inserePontos/2, inserePontosVolta/2 — fill remaining cells with points when a row/region/column is closed
- Queries & coordinates
  - objectosEmCoordenadas/3 — objects at coordinates
  - coordObjectos/5 — find coordinates of objects
  - coordenadasVars/2 — work with coordinate variables
- Strategies & patterns
  - fechalistaCoordenadas/2, fecha/2 — close rows/cols/regions when required
  - encontraSequencia/4 — find sequences of variables to apply pattern rules
  - aplicaPadraoI/2, aplicaPadroes/2 — apply pattern-based deductions
- Solver
  - resolve/2 — attempt to solve a puzzle given an initial board

---

## Provided files

- puzzles.pl — a set of sample puzzles for testing
- codigoAuxiliar.pl — helper predicates (do not modify)
- projecto.pl — main program (load this file in SWI-Prolog) — note: load the file that contains your project entry point if its name differs

---

## Requirements & configuration

- SWI-Prolog (recommended recent version)
- library(clpfd) (used for transpose/2 and other utilities)
- Recommended Prolog flag for pretty output:
  set_prolog_flag(answer_write_options, [max_depth(0)])

---

## Installation & running

1. Clone the repository:
   ```
   git clone https://github.com/LeoPlix/LP-Project.git
   cd LP-Project
   ```

2. Start SWI-Prolog and load the project file (example):
   ```prolog
   ?- [projecto].
   ```
   (Replace `projecto` with the actual top-level file name if different.)

3. Run a test puzzle (example):
   ```prolog
   ?- sol(9-2, Tab), resolve(E, Tab).
   ```
   - `sol(9-2, Tab)` loads/constructs the sample board indexed by `9-2` into `Tab`.
   - `resolve(E, Tab)` runs the solver producing a board (or solution trace) in `E`.

---

## Implemented solving strategies

1. Row / Column / Region closing rules
   - H1 — If a row/column/region already has 2 stars, mark all remaining cells as points.
   - H2 — If a row/column/region has 1 star and 1 free cell, that free cell becomes a star.
   - H3 — If a row/column/region has 0 stars and exactly 2 free cells, insert stars in those two cells.

2. Sequence patterns
   - Pattern I (three consecutive variables): deduce stars must be placed on both ends.
   - Pattern T (four consecutive variables): a specific deduction applied to certain arrangements.

These rules are applied iteratively to reduce the search space and produce deterministic progress before any backtracking search is used.

---

## Testing

Use the puzzles in puzzles.pl for quick validation. You can create your own puzzles by following the board representation used in the examples, then run resolve/2 to see how the solver proceeds.

---

## Contributing

Contributions are welcome. Suggestions:
- Add more test puzzles and edge cases.
- Implement more advanced deduction rules and heuristics.
- Add a small web or terminal UI for interactive play.

Please open issues or pull requests on GitHub describing your proposed change.

---

## License & contact

This project was created for academic purposes. Check the repository for a LICENSE file or contact the author for reuse permissions.

Author / Maintainer: LeoPlix

---

Enjoy exploring Star Battle solving with Prolog!
