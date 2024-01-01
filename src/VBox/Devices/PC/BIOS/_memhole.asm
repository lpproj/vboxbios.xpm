include commondefs.inc

ifndef MEMHOLE_SIZE
MEMHOLE_SIZE	equ	1024
;SIGXP_OFFSET	equ	256
endif

ifdef SIGXP_OFFSET
MEMHOLE_1	equ	(SIGXP_OFFSET)
MEMHOLE_2	equ	(MEMHOLE_SIZE - (SIGXP_OFFSET) - 51)
else
MEMHOLE_1	equ	-1
MEMHOLE_2	equ	(MEMHOLE_SIZE)
endif
if MEMHOLE_2 lt 0
	.err	wrong macro (MEMHOLE_SIZE and SIGXP_OFFSET)
endif


public		_memory_hole_begin
public		_memory_hole_end

_TEXT		segment para public 'CODE'

_memory_hole_begin:
if (MEMHOLE_SIZE) gt 0
	if MEMHOLE_1 gt 0
		db	MEMHOLE_1 dup (0)
	endif
	if MEMHOLE_1 ge 0
public		_xpm_signature
_xpm_signature:
	include "_sigxpm.inc"
	endif
	if MEMHOLE_2 gt 0
		db	MEMHOLE_2 dup (0)
	endif
endif			; (MEMHOLE_SIZE) gt 0
_memory_hole_end:

_TEXT		ends

		end

