.686
.model flat
public _main
; externy tutaj
extern _MessageBoxA@16 : PROC
extern _MessageBeep@4 : PROC
extern _ExitProcess@4 : PROC
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

	push	24h
	push	OFFSET tytul
	push	OFFSET tekst
	push	0
	call	_MessageBoxA@16
	add		esp, 16

	cmp		eax, 6
	jne		koniec

	push	0
	call	_MessageBeep@4
	add		esp, 4

koniec:

	mov		esp, ebp
	pop		ebp
	push	0
	call _ExitProcess@4
_main ENDP
END