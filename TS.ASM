; cl65.exe -t cx16 -o TS.PRG TS.ASM
; 64tass.exe TS.ASM -o TS.PRG

IRQVL = $0314
IRQVH = $0315
TIME_SLICES = 30

; STACK PAGED IN
; ACTIVE
; GROUP    [2]
; PRIORITY [3]

                .cpu "65c02"
                *= $0801   ; BASIC header
                .word (+), 2024
                .null $9e, format("%4d", start)
+               .word 0

; INITSTACK
start           SEI
                TSX
                STX SP0         ;SAVE CURRENT STACK POINTER

; SET UP TASK1 RTS DESTINATION
                LDX #$7F
                TXS
                LDA #>CLEANUP
                PHA
                LDA #<CLEANUP-1
                PHA

; SET UP TASK1 START
                LDA #>TASK1
                PHA
                LDA #<TASK1
                PHA
                LDA #$20  ;STATUS REGISTER
                PHA
                LDA #$00  ;ACC
                PHA
                LDA $01   ;ROM BANK
                PHA
                LDA #$03  ;ROUTINE FOR ROM BANK
                PHA
                LDA #$C3
                PHA
                PHP
                LDA #$00
                PHA
                PHA
                PHA
                TSX
                STX SP1
    
                LDA #$01
                STA FLG0  ;SET ENABLE FLAG
                STZ FLG1  ;SET ENABLE FLAG
    
                LDA IRQVL
                STA IRQL
                LDA IRQVH
                STA IRQH
    
                LDA #TIME_SLICES  ;30 JIFFIES
                STA TS
                STZ TID  ;TASK ID
    
                LDA #<INT
                STA IRQVL
                LDA #>INT
                STA IRQVH
    
                LDX SP0
                TXS
                CLI
                RTS
    

INT:
                DEC TS
                BPL INTEND
                LDA #TIME_SLICES
                STA TS
                TSX
                TXA
                LDY TID
                STA SP0,Y
INT2:
                INY
                CPY #$02  ;MAX TASKS
                BNE INT1
                LDY #$00
INT1:
                STY TID
                LDA FLG0,Y
                BEQ INT2
                LDX SP0,Y
                TXS

INTEND:
                JMP (IRQL)

CLEANUP:
                SEI
                LDA #$00
                LDY TID
                STA FLG0,Y
                STZ TS
                CLI
                BRK

TASK1:
                INC DATA
                BRA TASK1

SP0:            .BYTE $00
SP1:            .BYTE $00
FLG0:           .BYTE $00
FLG1:           .BYTE $00
TS:             .BYTE $00
TID:            .BYTE $00

IRQL:           .BYTE $00
IRQH:           .BYTE $00

DATA:           .BYTE $00
