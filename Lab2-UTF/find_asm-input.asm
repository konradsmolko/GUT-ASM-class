; int find(char* str, char c, int n)
; str - wsk. do stringa
; c - szukany znak
; n - miejsce od którego szukam
; ret - miejsce na ktorym jest znak (od poczatku stringa, nie od n). brak c = ret -1
.686
.model flat
public _find
extern _read : PROC
extern _write : PROC
extern _getchar : PROC
extern _strtol : PROC
extern _printf : PROC

.data
	input1	db "Podaj tekst (do 125 znakow)", 0Ah ; 0Ah = \n
	input2	db "Podaj znak do wyszukania", 0Ah
	input3	db "Od ktorej pozycji szukac?", 0Ah
	format	db "Pozycja: %i", 0

	string	db 126 dup (0) ; "str" jest mnemonikiem
	dchar	db ?, ?
	sint	dd ? ; max. liczba znaków - 0FFFFh
	slen	dd ?

.code
_find PROC
	; push ramka stosu
	push	ebp
	mov		ebp, esp
	push	ebx
	push	edi
	push	esi
	; push koniec ramki stosu

	; wczytywanie danych
	lea		eax, input1
	push	28
	push	eax
	push	1
	call	_write
	add		esp, 12 ; oczyszczenie stosu z parametrow

	lea		eax, string
	push	125
	push	eax
	push	0
	call	_read
	add		esp, 12 ; oczyszczenie stosu z parametrow
	;push	eax ; zapisuje ilosc znakow
	mov		slen, eax ; zapisuje ilosc znakow

	lea		eax, input2
	push	25
	push	eax
	push	1
	call	_write
	add		esp, 12 ; oczyszczenie stosu z parametrow

	;lea		eax, dchar
	;push	2
	;push	eax
	;push	0
	;call	_read
	;add		esp, 12 ; oczyszczenie stosu z parametrow
	call	_getchar
	mov		[dchar], al

	lea		eax, input3
	push	26
	push	eax
	push	1
	call	_write
	add		esp, 12 ; oczyszczenie stosu z parametrow

	lea		eax, sint
	push	4
	push	eax
	push	0
	call	_read
	add		esp, 12 ; oczyszczenie stosu z parametrow

	; int strtol(*str, *terminator, base)
	lea		eax, sint
	push	10
	push	0
	push	eax
	call	_strtol
	add		esp, 12 ; oczyszczenie stosu z parametrow
	;koniec wczytywania danych

	mov		edx, eax
	;pop		eax
	mov		eax, slen
	cmp		edx, eax ; sprawdzenie czy n nie jest wiêksze od dlugosci stringa
	jg		brak_znaku

	xor		eax, eax
	xor		ecx, ecx
	lea		ebx, string
	mov		cl, [dchar]

nastepny:
	mov		al, [ebx+edx] ; pobranie znaku
	inc		edx
	cmp		al, cl
	je		koniec
	cmp		edx, slen ; przypadek, gdy string wypelnil bufor i nie ma zera konczacego
	jge		brak_znaku
	cmp		al, 0
	jne		nastepny

brak_znaku:
	mov		edx, -1 ; doszlismy do konca stringa i brak znaku - zwracamy -1
	jmp		koniec

koniec:
	; int printf ( const char * format, ... );
	lea		eax, format
	push	edx
	push	eax
	call	_printf
	add		esp, 8 ; oczyszczenie stosu z parametrow

	;add		edx, 30h ; int > char
	;mov		sint, edx
	;lea		edx, sint
	;push	1
	;push	edx
	;push	1
	;call	_write
	;add		esp, 12 ; oczyszczenie stosu z parametrow

	; pop ramka stosu
	pop		esi
	pop		edi
	pop		ebx
	pop		ebp
	; end koniec ramki stosu

	mov		eax, edx
	ret
_find ENDP
END