.686
.model flat
public _main
.data
	bufor dq 256 dup (12345678ABCDEF0Eh)
	wynik dq 256 dup (?)
	granica	dd 11111111h ; debug - sprawdzenie czy petla nie wychodzi poza zakres wyniku
.code
_main PROC
	pusha

	mov		esi, OFFSET bufor
	mov		edi, OFFSET wynik
	mov		ecx, 256*8
	xor		ebx, ebx
	xor		eax, eax

	mov		dl, BYTE PTR [esi+ebx] ; 0Eh ; pierwsze 2 bajty
	mov		dh, dl ; 0Eh ; skopiowanie

	mov		ah, dh
	and		ah, 80h ; zapisanie pierwszego bitu

	shl		dh, 1 ; przygotowanie do op. xnor
	mov		al, BYTE PTR [esi+ebx+1]
	rol		al, 1
	and		al, 00000001b
	and		dh, 11111110b
	or		dh, al ; wpisanie ostatniego bitu z kolejnego bajtu

	xor		dl, dh
	not		dl ; główna funkcja dekodująca

	ror		dx, 1 ; pierwszy bit dh = xnor 7 i 8 bitu danych
	and		dl, 01111111b ; wyzerowanie 1 bitu wyniku
	or		dl, ah ; wpisanie pierwszego bitu

	mov		[edi+ebx], BYTE PTR dl

	inc		ebx
	dec		ecx
main_loop:
	mov		dl, BYTE PTR [esi+ebx] ; pierwsze 2 bajty
	mov		ah, dh
	and		ah, 80h ; zapisanie pierwszego bitu
	mov		dh, dl ; skopiowanie

	mov		al, BYTE PTR [esi+ebx+1]
	rol		al, 1
	and		al, 00000001b
	shl		dh, 1 ; przygotowanie do op. xnor
	and		dh, 11111110b
	or		dh, al ; wpisanie ostatniego bitu z kolejnego bajtu

	xor		dl, dh
	not		dl ; główna funkcja dekodująca

	ror		dx, 1 ; pierwszy bit dh = xnor 7 i 8 bitu danych
	and		dl, 01111111b ; wyzerowanie 1 bitu wyniku
	or		dl, ah ; wpisanie pierwszego bitu

	mov		[edi+ebx], BYTE PTR dl

	inc		ebx
debug_dalej:
	loop main_loop



	popa
	ret
_main ENDP
END