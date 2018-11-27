.686
.model flat
public _main
public wyswietl_EAX
public _convert
public _max ; int max(int spos, int* tab)
extern __read : PROC
extern __write : PROC
extern _strtol : PROC
extern _ExitProcess@4 : PROC
.data
	input1 db "Podaj 6 liczb do tablicy...", 0Ah

	tablica dd 6 dup (0)
	znaki db 12 dup ('o')
.code
_max PROC
	push	ebp
	mov		ebp, esp
	pusha



	popa
	pop		ebp
	ret
_max ENDP
_convert PROC
	push	ebp
	mov		ebp, esp
	pusha
	mov		eax, [ebp+8]

	;mov		eax, 0AAh
	mov     esi, 10        ; indeks w tablicy 'znaki' 
	mov     ebx, 10        ; dzielnik równy 10 
konwersja: 
	mov		edx, 0    ; zerowanie starszej czêœci dzielnej 
	div     ebx       ; dzielenie przez 10, reszta w EDX, 
	; iloraz w EAX 
	add     dl, 30H   ; zamiana reszty z dzielenia na kod 
	; ASCII 
	mov     znaki [esi], dl; zapisanie cyfry w kodzie ASCII 
	dec     esi            ; zmniejszenie indeksu 
	cmp     eax, 0         ; sprawdzenie czy iloraz = 0 
	jne     konwersja      ; skok, gdy iloraz niezerowy 
	; wype³nienie pozosta³ych bajtów spacjami i wpisanie 
	; znaków nowego wiersza 
wypeln: 
	or      esi, esi 
	jz      koniec       ; skok, gdy ESI = 0 
	mov     byte PTR znaki [esi], 20H ; kod spacji 
	dec     esi            ; zmniejszenie indeksu 
	jmp     wypeln 
koniec: 
	mov     byte PTR znaki [0], 20H; kod nowego wiersza 
	mov     byte PTR znaki [11], 0AH ; kod nowego wiersza
	; wyœwietlenie cyfr na ekranie 
	push    dword PTR 12   ; liczba wyœwietlanych znaków 
	push    dword PTR OFFSET znaki   ; adres wyœw. obszaru 
	push    dword PTR 1; numer urz¹dzenia (ekran ma numer 1) 
	call    __write        ; wyœwietlenie liczby na ekranie 
	add     esp, 12        ; usuniêcie parametrów ze stosu
	popa
	pop		ebp
	ret
_convert ENDP
wyswietl_EAX PROC
	pusha
	push	eax
	call	_convert
	add		esp, 4
	popa
	ret
wyswietl_EAX ENDP
_main PROC
	;zad. 3.1
	mov		ecx, 50
	mov		eax, 0
ptl:
	add		eax, 3
	call	wyswietl_EAX
	loop	ptl

	; zad. 3.3
	lea		eax, input1
	push	28
	push	eax
	push	1
	call	__write
	add		esp, 12

	mov		ecx, 6
	lea		ebx, tablica
	add		ebx, 5*4
ptl2:
	push	ecx ; __read zmienia mi ecx
	push	4
	push	ebx
	push	0
	call	__read
	add		esp, 12
	pop		ecx
	sub		ebx, 4
	loop	ptl2
	;	tablica zawiera 6 ci¹gów znaków jako chary

	mov		ecx, 0
ptl3:
	push	ecx
	; int strtol(*str, *terminator, base)
	lea		ebx, [ecx+tablica]
	push	10
	push	0
	push	ebx
	call	_strtol
	add		esp, 12 ; oczyszczenie stosu z parametrow
	bswap	eax
	mov		[ebx], eax
	pop		ecx
	add		ecx, 4
	cmp		ecx, 24
	jl		ptl3

	push	0
	call	_ExitProcess@4
_main ENDP
END