# cx16-rtos
Multitasking library module for Commander X16 8-bit computer, inspired by FreeRTOS

DEMO STEPS:

SP0: DE
SP1: 72
FLG0: 01
FLG1: 00
TS:   xx  ;00 - 1E
TID:  00  ; main
IRQL: CD
IRQH: EA

DATA: 00

RUN to install task switching and add TASK1. TASK1 doesn't start until enabled.

Set FLG1 to 1 to start TASK1. DATA will start to increase
Set FLG1 to 0 to pause TASK1.
