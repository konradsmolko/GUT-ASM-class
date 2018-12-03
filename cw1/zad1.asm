.686
.model flat
public _main
.data
	bufor dq 256 dup (01234567ABCDEF0Eh)
	wynik dq 256 dup (?)
	granica	db 0FFh ; debug - sprawdzenie czy petla nie wychodzi poza zakres wyniku
					; wynik ostatniego bitu w wyniku nie zależy od wartości w granicy (0 lub F)
.code
_main PROC
	pusha

	mov		esi, OFFSET bufor
	mov		edi, OFFSET wynik
	mov		ecx, 256*8
	xor		ebx, ebx
	xor		eax, eax

	mov		dh, BYTE PTR [esi+ebx] ; pierwszy bajt, tylko na potrzeby zapisania pierwszego bitu kodu

main_loop:
	mov		ah, dh
	and		ah, 80h ; zapisanie pierwszego bitu danej pary bajtów

	mov		dl, BYTE PTR [esi+ebx] ; pierwszy bajt
	mov		dh, dl ; skopiowanie

	mov		al, BYTE PTR [esi+ebx+1]
	rol		al, 1
	and		al, 00000001b
	shl		dh, 1 ; przygotowanie do op. xnor
	and		dh, 11111110b
	or		dh, al ; wpisanie pierwszego bitu z kolejnego bajtu

	xor		dl, dh
	not		dl ; dekodowanie - operacja xnor

	ror		dx, 1 ; pierwszy bit dh = xnor 8 i 9 bitu danych w każdej pętli
	and		dl, 01111111b ; wyzerowanie 1 bitu wyniku
	or		dl, ah ; wpisanie pierwszego (już zdekodowanego) bitu

	mov		[edi+ebx], BYTE PTR dl ; zapisanie zdekodowanego bajtu

	inc		ebx
	loop main_loop

	popa
	ret
_main ENDP
END