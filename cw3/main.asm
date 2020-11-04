; W 36-bajtowej tablicy bufor znajduje sie tekst Polaczenie zostalo nawiazane.piatka (w kólku) zakodowany w formacie UTF-8
; Napisac program w asemblerze, który wyswietli ten tekst na ekranie w postaci komunikatu typu MessageBoxW.
; Funkcja MessageBoxW wyswietla znaki zakodowane w formacie UTF-16.
; Uwaga: w podanej tablicy wystepuja ciagi 1-, 2- i 3-bajtowe (ciagi 4-bajtowe nie wystepuja).

.686
.model flat

extern	_MessageBoxW@16	: PROC
extern	_ExitProcess@4	: PROC

public _main

.data

    bufor   db	50H, 6FH, 0C5H, 82H, 0C4H, 85H, 63H, 7AH
            db	65H, 6EH,  69H, 65H,  20H, 7AH, 6FH, 73H
            db	74H, 61H, 0C5H, 82H,  6FH, 20H, 6EH, 61H
            db	77H, 69H, 0C4H, 85H,  7AH, 61H, 6EH, 65H
            db	2EH					; 1- i 2-bajtowe znaki
			db	0E2H, 91H, 0A4H		; 3-bajtowy znak
			db	0f0h, 0a0h, 9ch, 8eh	; 4-bajtowy znak (chiñski)

    wynik   db    74 dup (?)    
                    
.code
_main PROC
    mov		ecx, 40                ; liczba bajtów tablicy zródlowej
    mov		esi, OFFSET bufor      ; adres tabilicy wejsciowej
    mov		edi, OFFSET wynik

przetwarzanie:
    mov		bx, 0
    mov		al, [esi]
    rcl		al, 1                   ; przesuwamy bity w lewo, jesli 1 byla na najstarszym bicie to CF = 1
    jc		znak_wielobajtowy

; przypadek zwyklego ASCII (kodowane na jednym bajcie)
znak_ASCII:    
    rcr		al, 1                    ; przesuwamy bity w prawo (wracamy do poprzedniego stanu)
    mov		bl, al
    inc		esi
    dec		ecx
    jmp		gotowe

; tutaj wchodzimy gdy znak nie jest podstawowym ASCII
znak_wielobajtowy:
    rcl		al, 2
    jc		trzy_bajty

; przypadek znaku kodowanego na 2 bajtach
; format: 110yyyyy 10xxxxxx
    rcr		al, 3                       ; wracamy do poprzedniego stanu
    and		al, 00011111B               ; usuwamy 3 pierwsze jedynki jesli istnieja
    mov		bl, al                      ; wrzucamy starsze bity
    shl		bx, 6                       ; robimy miejsce dla kolejnych 6 'x-ow', (aktualnie BX: 00000yyy yy000000)
    mov		al, [esi + 1]               ; wrzucamy te 10xxxxxx
    and		al, 00111111B               ; usuwamy to 10 na poczatku
    or		bl, al                      ; wrzuca sie x do gx -> 00000yyy yyxxxxxx
    add		esi, 2                      ; uzylismy juz 2 bajtow z bufora
    sub		ecx, 2                      ; dlatego iterator tez zmniejsza sie o 2
    jmp		gotowe

; todo 4 students
trzy_bajty:
	rcl		al, 1
	jc		cztery_bajty

	rcr		al, 4
	and		al, 00001111b
	mov		bl, al
	shl		bx, 6

	mov		al, [esi+1]
	and		al, 00111111b
	or		bl, al
	shl		bx, 6

	mov		al, [esi+2]
	and		al, 00111111b
	or		bl, al

	add		esi, 3
	sub		ecx, 3
	jmp		gotowe

cztery_bajty:
	xor		ebx, ebx
	rcr		al, 4
	and		al, 00000111b
	mov		bl, al
	shl		ebx, 6

	mov		al, [esi+1]
	and		al, 00111111b
	or		bl, al
	shl		ebx, 6

	mov		al, [esi+2]
	and		al, 00111111b
	or		bl, al
	shl		ebx, 6

	mov		al, [esi+3]
	and		al, 00111111b
	or		bl, al

	add		esi, 4
	sub		ecx, 4

	;add		edi, 2
	mov		[edi], ebx
	jmp		gotowe_4bajty

; kod UTF16 zawarty jest w BX
gotowe:
    mov		[edi], bx
gotowe_4bajty:
    add		edi, 2
    or		ecx, ecx                 ; najszybsze sprawdzanie czy cos jest rowne 0
    jnz		przetwarzanie

    mov		[edi], word PTR 0

    push	0
    push	OFFSET wynik
    push	OFFSET wynik
    push	0
    call	_MessageBoxW@16
    
    
    push    0
    call    _ExitProcess@4

_main ENDP

END