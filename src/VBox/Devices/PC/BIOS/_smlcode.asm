include commondefs.inc

_TEXT		segment byte public 'CODE'

; workaround for (Open)Watcom small model
public		_small_code_

_small_code_	db	1

_TEXT		ends

		end

