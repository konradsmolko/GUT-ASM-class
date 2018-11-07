; wczytywanie i wyœwietlanie tekstu wielkimi literami
; (inne znaki siê nie zmieniaja)
.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC ; (dwa znaki podkreslenia)
extern __read  : PROC ; (dwa znaki podkreslenia)
public  _duzelitery

.data
	tekst_pocz	db	10, 'Proszê napisaæ jakiœ tekst '
				db	'i nacisnac Enter', 10
	koniec_t	db	?
	magazyn	db	80	dup (?)
	nowa_linia	db	10
	liczba_znakow	dd ?

.code
_duzelitery PROC
	; wyœwietlenie tekstu informacyjnego
	; liczba znaków tekstu
	mov     ecx,(OFFSET koniec_t)-(OFFSET tekst_pocz)
	push    ecx
	push    OFFSET tekst_pocz  ; adres tekstu
	push	1; nr urz¹dzenia (tu: ekran -nr 1)
	call    __write  ; wyœwietlenie tekstu pocz¹tkowego
	add     esp, 12
	; usuniecie parametrów ze stosu
	; czytanie wiersza z klawiatury
	push    80 ; maksymalna liczba znaków
	push    OFFSET magazyn
	push    0  ; nr urz¹dzenia (tu: klawiatura -nr 0)
	call    __read ; czytanie znaków z klawiatury
	add     esp, 12
	; usuniecie parametrów ze stosu
	; kody ASCII napisanego tekstu zosta³y wprowadzone
	; do obszaru 'magazyn'
	; funkcja read wpisuje do rejestru EAX liczbê
	; wprowadzonych znaków
	mov     liczba_znakow, eax
	; rejestr ECX pe³ni rolê licznika obiegów pêtli
	mov     ecx, eax
	mov     ebx, 0
	; indeks pocz¹tkowy
ptl:  
	mov     dl, magazyn[ebx] ; pobranie kolejnego znaku

	cmp		dl, 0A5h
	je		malea
	cmp		dl, 086h
	je		malec
	cmp		dl, 0A9h
	je		malee
	cmp		dl, 088h
	je		malel
	cmp		dl, 0E4h
	je		malen
	cmp		dl, 0A2h
	je		maleo
	cmp		dl, 098h
	je		males
	cmp		dl, 0ABh
	je		malez
	cmp		dl, 0BEh
	je		malezz

	cmp     dl, 'a'
	jb      dalej   ; skok, gdy znak nie wymaga zamiany
	cmp     dl, 'z'
	ja      dalej   ; skok, gdy znak nie wymaga zamiany
	sub     dl, 20H ; zamiana na wielkie litery
	; odes³anie znaku do pamiêci
	mov     magazyn[ebx], dl
	jmp		dalej

malea:
malee:
malen:
males:
malezz:
	dec		dl
	jmp		save
malec:
	mov		dl, 08Fh
	jmp		save
malel:
	mov		dl, 09Dh
	jmp		save
maleo:
	mov		dl, 0E0h
	jmp		save
malez:
	mov		dl, 08Dh
	jmp		save

save:
	mov		magazyn[ebx], dl
	jmp		dalej

dalej:
	inc     ebx 
	; inkrementacja indeksu
	loop    ptl     ; sterowanie pêtl¹
	; wyœwietlenie przekszta³conego tekstu
	push  liczba_znakow
	push    OFFSET magazyn
	push    1
	call    __write  ; wyœwietlenie przekszta³conego tekstu
	add     esp, 12  ; usuniecie parametrów ze stosu
	push    0
	call    _ExitProcess@4   ; zakoñczenie programu
_duzelitery ENDP
END