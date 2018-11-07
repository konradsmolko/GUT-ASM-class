.686
.model flat

extern _ExitProcess@4 : PROC
extern _MessageBoxW@16 : PROC
public _unicode

.data
	tytul_Unicode	dw 'Z', 'n', 'a', 'k', 'i', 0
	tekst_Unicode	dw 'O', 'x', ' ', 0D83Dh, 0DC02h, ' '
					dw 'i', ' ', 'm', 'y', 's', 'z', ' ', 0D83Dh, 0DC01h, 0
					;dw 1101 1000 0011 1101, 1101 1100 0000 0001
					;1101 10 x F401
					;1101 11 y

.code
_unicode PROC
	push	0
	push	OFFSET tytul_Unicode
	push	OFFSET tekst_Unicode
	push	0
	call	_MessageBoxW@16

	push	0
	call	_ExitProcess@4
_unicode ENDP
END