; wczytywanie i wy�wietlanie tekstu wielkimi literami
; (inne znaki si� nie zmieniaja)
.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC ; (dwa znaki podkreslenia)
extern __read  : PROC ; (dwa znaki podkreslenia)
public  _duzelitery

.data
	tekst_pocz	db	10, 'Prosz� napisa� jaki� tekst '
				db	'i nacisnac Enter', 10
	koniec_t	db	?
	magazyn	db	80	dup (?)
	nowa_linia	db	10
	liczba_znakow	dd ?

.code
_duzelitery PROC
	; wy�wietlenie tekstu informacyjnego
	; liczba znak�w tekstu
	mov     ecx,(OFFSET koniec_t)-(OFFSET tekst_pocz)
	push    ecx
	push    OFFSET tekst_pocz  ; adres tekstu
	push	1; nr urz�dzenia (tu: ekran -nr 1)
	call    __write  ; wy�wietlenie tekstu pocz�tkowego
	add     esp, 12
	; usuniecie parametr�w ze stosu
	; czytanie wiersza z klawiatury
	push    80 ; maksymalna liczba znak�w
	push    OFFSET magazyn
	push    0  ; nr urz�dzenia (tu: klawiatura -nr 0)
	call    __read ; czytanie znak�w z klawiatury
	add     esp, 12
	; usuniecie parametr�w ze stosu
	; kody ASCII napisanego tekstu zosta�y wprowadzone
	; do obszaru 'magazyn'
	; funkcja read wpisuje do rejestru EAX liczb�
	; wprowadzonych znak�w
	mov     liczba_znakow, eax
	; rejestr ECX pe�ni rol� licznika obieg�w p�tli
	mov     ecx, eax
	mov     ebx, 0
	; indeks pocz�tkowy
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
	; odes�anie znaku do pami�ci
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
	loop    ptl     ; sterowanie p�tl�
	; wy�wietlenie przekszta�conego tekstu
	push  liczba_znakow
	push    OFFSET magazyn
	push    1
	call    __write  ; wy�wietlenie przekszta�conego tekstu
	add     esp, 12  ; usuniecie parametr�w ze stosu
	push    0
	call    _ExitProcess@4   ; zako�czenie programu
_duzelitery ENDP
END