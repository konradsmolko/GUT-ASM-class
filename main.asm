.686
.model flat
extern	_ExitProcess@4 : PROC
extern	_MessageBoxA@16 : PROC
extern	__write : PROC
extern	__read : PROC
public	_main

.data
tekst_pocz		db 10, 'Proszę napisać jakiś tekst '
				db 'i nacisnac Enter', 10
koniec_t		db ?
magazyn			db 80 dup (?)
nowa_linia		db 10
liczba_znakow	dd ?
tytul			db 'tytul',0

.code
_main PROC
	mov		ecx, (OFFSET koniec_t) - (OFFSET tekst_pocz)
	push	ecx
	push	OFFSET tekst_pocz
	push	1
	call	__write
	add		esp, 12

	push	80
	push	OFFSET magazyn
	push	0
	call	__read
	add		esp, 12

	mov		liczba_znakow, eax

; tu zamienic znaki z kodowania Latin2 na W1250
	mov		ecx, liczba_znakow
	dec		ecx
	mov		esi, 0

clp:
	mov		al,	magazyn[esi]
	cmp		al, 0a5h
	je		a_ogonek
	cmp		al, 086h
	je		c_kreska
	cmp		al, 0a9h
	je		e_ogonek
	cmp		al, 088h
	je		l_kreska
	cmp		al, 0e4h
	je		n_kreska
	cmp		al, 0a2h
	je		o_kreska
	cmp		al, 098h
	je		s_kreska
	cmp		al, 0abh
	je		z_kreska
	cmp		al, 0beh
	je		z_kropka
	jmp		dalej
a_ogonek:
	mov		al, 0b9h
	jmp		zapis
c_kreska:
	mov		al, 0e6h
	jmp		zapis
e_ogonek:
	mov		al, 0eah
	jmp		zapis
l_kreska:
	mov		al, 0b3h
	jmp		zapis
n_kreska:
	mov		al, 0f1h
	jmp		zapis
o_kreska:
	mov		al, 0f3h
	jmp		zapis
s_kreska:
	mov		al, 09ch
	jmp		zapis
z_kreska:
	mov		al, 09fh
	jmp		zapis
z_kropka:
	mov		al, 0bfh
zapis:
	mov		magazyn[esi], al
dalej:
	inc		esi
	loop	clp

; tu zamienic kolejnosc tekstu
; magazyn[liczba_znakow] = \0
	mov		ecx, liczba_znakow
	dec		ecx
	mov		esi, 0
	mov		edi, ecx
	mov		magazyn[edi], 0
	dec		edi
	shr		ecx, 1 ; w przypadku liczby nieparzystej nie ma problemu!

petla_zamiany:
	mov		al, magazyn[esi]
	mov		ah, magazyn[edi]
	mov		magazyn[esi], ah
	mov		magazyn[edi], al
	inc		esi
	dec		edi
	loop	petla_zamiany
	
; tu wypisac z uzyciem messageboxa
	push	0
	push	OFFSET tytul
	push	OFFSET magazyn
	push	0
	call	_MessageBoxA@16

	push	0
	call	_ExitProcess@4
_main ENDP
end
