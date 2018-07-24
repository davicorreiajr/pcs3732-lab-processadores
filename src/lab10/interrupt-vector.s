.global _start
.text
_start:
	b _Reset @posição 0x00 - Reset
	ldr pc, _undefined_instruction @posição 0x04 - Intrução não-definida
	ldr pc, _software_interrupt @posição 0x08 - Interrupção de Software
	ldr pc, _prefetch_abort @posição 0x0C - Prefetch Abort
	ldr pc, _data_abort @posição 0x10 - Data Abort
	ldr pc, _not_used @posição 0x14 - Não utilizado
	ldr pc, _irq @posição 0x18 - Interrupção (IRQ)
	ldr pc, _fiq @posição 0x1C - Interrupção(FIQ)
	
_undefined_instruction: .word undefined_instruction
_software_interrupt: .word software_interrupt
_prefetch_abort: .word prefetch_abort
_data_abort: .word data_abort
_not_used: .word not_used
_irq: .word irq
_fiq: .word fiq
