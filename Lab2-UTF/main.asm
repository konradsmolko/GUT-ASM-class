extern _ExitProcess@4 : PROC
extern __write : PROC ; (dwa znaki podkreslenia)
extern __read  : PROC ; (dwa znaki podkreslenia)
public  _main
.data
tekst_pocz	db 10, 'Prosze napisa? jakis tekst '
			db 'i nacisnac Enter', 10
koniec_t	db ?
magazyn		db 80 dup (?)
nowa_linia	db 10
liczba_znakow dd ?
.code
_main:
	; wyswietlenie tekstu informacyjnego
	; liczba znakow tekstu
	mov     ecx, (OFFSET koniec_t) - (OFFSET tekst_pocz)
	push    ecx
	push    OFFSET tekst_pocz  ; adres tekstu
	push	1 ; nr urz?dzenia (tu: ekran - nr 1)
	call    __write  ; wyswietlenie tekstu pocz?tkowego
	add     esp, 12 ; usuniecie parametrow ze stosu
	; czytanie wiersza z klawiatury
	push    80 ; maksymalna liczba znakow
	push    OFFSET magazyn
	push    0  ; nr urz?dzenia (tu: klawiatura - nr 0)
	call    __read ; czytanie znakow z klawiatury
	add     esp, 12 ; usuniecie parametrow ze stosu
	; kody ASCII napisanego tekstu zosta?y wprowadzone
	; do obszaru 'magazyn'
	; funkcja read wpisuje do rejestru EAX liczbe
	; wprowadzonych znakow
	mov     liczba_znakow, eax
	; rejestr ECX pe?ni role licznika obiegow petli
	mov     ecx, eax
	mov     ebx, 0
	; indeks pocz?tkowy
	ptl:  
	mov     dl, magazyn[ebx] ; pobranie kolejnego znaku
	cmp     dl, 'a'
	jb      dalej   ; skok, gdy znak nie wymaga zamiany
	cmp     dl, 'z'
	ja      dalej   ; skok, gdy znak nie wymaga zamiany
	sub     dl, 20H ; zamiana na wielkie litery
	; odes?anie znaku do pamieci
	mov     magazyn[ebx], dl
	dalej:
	inc     ebx 
	; inkrementacja indeksu
	loop    ptl     ; sterowanie petl?
	; wyswietlenie przekszta?conego tekstu
	push  	liczba_znakow
	push    OFFSET magazyn
	push    1
	call    __write  ; wyswietlenie przekszta?conego tekstu
	add     esp, 12  ; usuniecie parametrow ze stosu
	push    0
	call    _ExitProcess@4   
	; zako?czenie programu
END