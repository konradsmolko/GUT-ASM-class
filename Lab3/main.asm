.686
.model flat
public _main
public _max ; int max(int spos, int* tab)
extern __read : PROC
extern __write : PROC
extern _strtol : PROC
extern _ExitProcess@4 : PROC
.data
	input1	db "Podaj 6 liczb do tablicy, a nastepnie pozycje od ktorej szukac (1..6)", 0Ah

	bufor	db 6 dup (?)
	tablica dd 6 dup (?)
	znaki	db 12 dup (?)
	i1len = bufor - input1
.code
_max PROC
	push	ebp
	mov		ebp, esp
	pusha



	popa
	mov		esp, ebp
	pop		ebp
	ret
_max ENDP
wyswietl_EAX PROC
	push	ebp
	mov		ebp, esp
	pusha

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
	mov     byte PTR znaki [0], 20H; kod spacji 
	mov     byte PTR znaki [11], 0AH ; kod nowego wiersza
	; wyœwietlenie cyfr na ekranie 
	push    dword PTR 12   ; liczba wyœwietlanych znaków 
	push    dword PTR OFFSET znaki   ; adres wyœw. obszaru 
	push    dword PTR 1; numer urz¹dzenia (ekran ma numer 1) 
	call    __write        ; wyœwietlenie liczby na ekranie 
	add     esp, 12        ; usuniêcie parametrów ze stosu
	popa
	mov		esp, ebp
	pop		ebp
	ret
wyswietl_EAX ENDP
wczytaj_do_EAX PROC
	push	ebp
	mov		ebp, esp

	push	6
	push	dword PTR OFFSET bufor
	push	0
	call	__read
	add		esp, 12

	; int strtol(*str, *terminator, base)
	push	10
	push	0
	push	dword PTR OFFSET bufor
	call	_strtol
	add		esp, 12 ; oczyszczenie stosu z parametrow

	mov		esp, ebp
	pop		ebp
	ret
wczytaj_do_EAX ENDP
zadanie1 PROC
	;zad. 3.1
	mov		ecx, 50
	mov		eax, 1
	mov		ebx, 0
ptl:
	add		eax, ebx
	push	eax
	push	ecx
	call	wyswietl_EAX
	pop		ecx
	pop		eax
	inc		ebx
	loop	ptl
	ret
zadanie1 ENDP
zadanie3 PROC
	push	ebp
	mov		ebp, esp
	call	wczytaj_do_EAX
	cmp		eax, 0EA60h
	jg		zadanie3_err_overflow
	jmp		zadanie3_read_ok

zadanie3_err_overflow:
	mov		eax, 0EA60h
	jmp		zadanie3_read_ok

zadanie3_read_ok:
	mov		ebx, eax
	mul		ebx ; wynik w edx:eax

	call	wyswietl_EAX

zadanie3_koniec:
	mov		esp, ebp
	pop		ebp
	ret
zadanie3 ENDP
zadaniemax PROC
	; int max(int spos, int* tab)
	; wczytanie 6 liczb do tablicy, miejsca od ktorego mam sprawdzac
	; i zwrocenie najwiekszej liczby
	push	ebp
	mov		ebp, esp
	push	ebx

	push	dword PTR i1len
	push	dword PTR OFFSET input1
	push	1
	call	__write
	add		esp, 12

	mov		ebx, 0
	mov		ecx, 6
zadaniemax_readloop:
	push	ecx
	call	wczytaj_do_EAX
	mov		[tablica+ebx*4], eax ; tablica = *tab
	inc		ebx
	pop		ecx
	loop	zadaniemax_readloop

	call	wczytaj_do_EAX ; eax = spos
	cmp		eax, 6
	jg		zadaniemax_err_out_of_range

	mov		ebx, eax
	dec		ebx ; indeks od 0
	mov		eax, 0
zadaniemax_dalej:
	mov		ecx, [tablica+ebx*4]
	inc		ebx
	cmp		eax, ecx
	jg		zadaniemax_sprawdz_indeks
	mov		eax, ecx
zadaniemax_sprawdz_indeks:
	cmp		ebx, 6
	jge		zadaniemax_koniec
	jmp		zadaniemax_dalej

zadaniemax_err_out_of_range:
	mov		eax, -1
	jmp		zadaniemax_koniec

zadaniemax_koniec:
	pop		ebx
	mov		esp, ebp
	pop		ebp
	ret
zadaniemax ENDP
_main PROC
	call	zadanie1
	call	zadanie3
	call	zadaniemax
	call	wyswietl_EAX
	push	0
	call	_ExitProcess@4
_main ENDP
END