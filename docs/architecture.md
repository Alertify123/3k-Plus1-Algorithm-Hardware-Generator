# System Architecture

This document captures the control-state and datapath/control decomposition for `part2.vhd`.

## ASM Chart (Control FSM)

### Mermaid source

```mermaid
stateDiagram-v2
    [*] --> RESET_STATE
    RESET_STATE --> TEST_STATE

    TEST_STATE --> GENERATE_NEXT: term_is_one = 0
    TEST_STATE --> INCREMENT: term_is_one = 1\nlength_ge_9 = 0
    TEST_STATE --> DONE_STATE: term_is_one = 1\nlength_ge_9 = 1

    INCREMENT --> RELOAD_TERM: inc_number
    RELOAD_TERM --> TEST_STATE: load_term\nreset_length

    GENERATE_NEXT --> DIVIDE: term_is_even = 1
    GENERATE_NEXT --> MULT_ADD: term_is_even = 0

    DIVIDE --> TEST_STATE: shift_term\ninc_length
    MULT_ADD --> TEST_STATE: do_mult\ninc_length

    DONE_STATE --> DONE_STATE: load_done
    DONE_STATE --> [*]
```

### Exported image assets

- SVG: `docs/assets/asm_chart.svg`

![ASM chart export](assets/asm_chart.svg)

## Datapath / Control Block Diagram

### Mermaid source

```mermaid
flowchart LR
    C[Control FSM] -->|inc_number| N[number_reg]
    C -->|load_term| T[term]
    C -->|shift_term| T
    C -->|do_mult| T
    C -->|reset_length| L[length]
    C -->|inc_length| L
    C -->|load_done| D[done]

    N -->|value| T

    T -->|term_is_one| C
    T -->|term_is_even| C
    L -->|length_ge_9| C
```

### Exported image assets

- SVG: `docs/assets/datapath_control.svg`

![Datapath/control export](assets/datapath_control.svg)


## Repository note

This repository keeps diagrams as Mermaid source and SVG exports only (no PNG binaries) to stay compatible with PR systems that reject binary files.
