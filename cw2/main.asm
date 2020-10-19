.686
.model flat
public _main
; externy tutaj
extern _MessageBoxA@16 : PROC
.data
	; dane statyczne tutaj
	tytul db 'Testowanie', 0
	tekst db 'Czy wyslac sygnal?', 0
.code
; procedury tutaj
_main PROC
	; kod tutaj
	push	ebp
	mov		ebp, esp

	push	41h
	push	OFFSET tytul
	push	OFFSET tekst
	push	0
	call	_MessageBoxA@16
	add		esp, 16

	mov		esp, ebp
	pop		ebp
	ret
_main ENDP
END