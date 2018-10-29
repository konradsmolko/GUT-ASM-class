; wczytywanie i wyświetlanie tekstu wielkimi literami
; (inne znaki się nie zmieniają)
.686
.model flat, stdcall
extern ExitProcess@4 : PROC
extern MessageBoxA@16 : PROC
;extern __write : PROC ; (dwa znaki podkreślenia)
;extern __read  : PROC ; (dwa znaki podkreślenia)
public  _main
.data
tekst_pocz	db 10, 'Proszę napisać jakiś tekst '
			db 'i nacisnac Enter', 10
koniec_t	db ?
magazyn		db 80 dup (?)
nowa_linia	db 10
liczba_znakow dd ?
.code
_main:
	; wyświetlenie tekstu informacyjnego
	; liczba znaków tekstu
	mov     ecx, (OFFSET koniec_t)-(OFFSET tekst_pocz)
	push    ecx
	push    OFFSET tekst_pocz	; adres tekstu
	push	1					; nr urządzenia (tu: ekran - nr 1)
	;call    __write				; wyświetlenie tekstu początkowego
	add     esp, 12				; usuniecie parametrów ze stosu
								; czytanie wiersza z klawiatury
	push    80					; maksymalna liczba znaków
	push    OFFSET magazyn
	push    0					; nr urządzenia (tu: klawiatura - nr 0)
	;call    __read				; czytanie znaków z klawiatury
	add     esp, 12				; usuniecie parametrów ze stosu
								; kody ASCII napisanego tekstu zostały wprowadzone
								; do obszaru 'magazyn'
								; funkcja read wpisuje do rejestru EAX liczbę
								; wprowadzonych znaków
	mov     liczba_znakow, eax
								; rejestr ECX pełni rolę licznika obiegów pętli
	mov     ecx, eax
	mov     ebx, 0				; indeks początkowy
ptl:  
	mov     dl, magazyn[ebx]	; pobranie kolejnego znaku
	cmp     dl, 'a'
	jb      dalej				; skok, gdy znak nie wymaga zamiany
	cmp     dl, 'z'
	ja      dalej				; skok, gdy znak nie wymaga zamiany
	sub     dl, 20H				; zamiana na wielkie litery
								; odesłanie znaku do pamięci
	mov     magazyn[ebx], dl
dalej:
	inc     ebx					; inkrementacja indeksu
	loop    ptl					; sterowanie pętlą
								; wyświetlenie przekształconego tekstu
	push  	liczba_znakow
	push    OFFSET magazyn
	push    1
	;call    __write				; wyświetlenie przekształconego tekstu
	add     esp, 12				; usuniecie parametrów ze stosu
	push    0
	;call    _ExitProcess@4   
	; zakończenie programu
END