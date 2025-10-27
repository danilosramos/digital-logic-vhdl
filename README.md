# Projetos de Lógica Digital e VHDL

Esta coleção de projetos demonstra a competência em **Lógica Digital** e **Design de Hardware** utilizando a **Hardware Description Language (HDL)** **VHDL**.

Os projetos foram desenvolvidos no contexto de disciplinas de Arquitetura de Computadores ou Lógica Digital, focando na implementação de circuitos digitais para simulação em ferramentas como o Xilinx ISE.

## Conceitos Demonstrados

*   **VHDL:** Conhecimento da sintaxe e semântica da VHDL para descrever circuitos digitais.
*   **Lógica Digital:** Implementação de componentes lógicos, como contadores, decodificadores, e máquinas de estados finitos.
*   **Simulação e Teste:** Uso de *Test Benches* (`TBproj1.vhd`, `TBproj2.vhd`, `FFD_TB.vhd`) para verificar o comportamento do hardware descrito.
*   **Síntese de Hardware:** Familiaridade com o fluxo de design para síntese em FPGAs (implícito pelo uso de arquivos de projeto do Xilinx ISE).

## Projetos Incluídos

| Projeto | Arquivos Principais | Descrição |
| :--- | :--- | :--- |
| **Contador/Cronômetro** | `cron_decr.vhd` | Implementação de um contador ou cronômetro digital em VHDL. |
| **Lógica Sequencial** | `proj2.vhd` | Implementação de um circuito de lógica sequencial (possivelmente um registrador ou contador). |
| **Flip-Flop D** | `FFD_TB.vhd` | Test Bench para um Flip-Flop D, componente fundamental da lógica sequencial. |
| **Outros Componentes** | `debounce.vhd` | Módulo para *debouncing* (eliminação de ruído) de sinais de entrada. |

## Como Visualizar e Analisar

Os arquivos `.vhd` são o código-fonte do hardware. Para simulação e síntese, é necessário o software **Xilinx ISE** ou ferramentas similares.

**Recomendação para Recrutadores:** O código VHDL em si é a evidência da habilidade. A análise dos arquivos `.vhd` e dos *Test Benches* demonstra a capacidade de projetar e verificar circuitos digitais.

---
**Linguagem:** VHDL
**Tópicos:** Lógica Digital, VHDL, Design de Hardware, Sistemas Digitais, FPGA.
'''
