.686 
.model flat 
public _szukaj_max ; int szukaj_max(int x, int y, int z)
public _szukaj4_max ; int szukaj4_max (int a, int b, int c, int d)
public _substitute ; int substitute(char* str, char w, char c)
.code
_substitute PROC
	push	ebp
	mov		ebp, esp

	mov		ebx, [ebp+8] ; *str
	xor		edx, edx
	mov		dl, byte PTR [ebp+12] ; w
	mov		dh, byte PTR [ebp+16] ; c
	mov		ecx, 0
	mov		ah, 0
ptl:
	mov		al, byte PTR [ebx+ecx] ; znak ze stringa
	cmp		al, 0 ;sprawdzenie czy koniec stringa
	je		koniec
	cmp		al, dl
	je		znaleziony
	inc		ecx
	jmp		ptl
znaleziony:
	mov		byte PTR [ebx+ecx], dh
	inc		ah
	inc		ecx
	jmp		ptl

koniec:
	shr		eax, 8
	and		eax, 000000FFh
	mov		esp, ebp
	pop		ebp
	ret
_substitute ENDP
_szukaj_max PROC
	push	ebp       ; zapisanie zawartoœci EBP na stosie
	mov		ebp, esp  ; kopiowanie zawartoœci ESP do EBP 
	mov		eax, [ebp+8]   ; liczba x 
	cmp		eax, [ebp+12]  ; porownanie liczb x i y 
	jge		x_wieksza      ; skok, gdy x >= y 
	; przypadek x < y 
	mov		eax, [ebp+12]  ; liczba y 
	cmp		eax, [ebp+16]  ; porownanie liczb y i z 
	jge		y_wieksza      ; skok, gdy y >= z 
	; przypadek y < z 
	; zatem z jest liczb¹najwieksz¹
wpisz_z:
	mov		eax, [ebp+16]  ; liczba z 
zakoncz: 
	pop		ebp 
	ret 
x_wieksza: 
	cmp		eax, [ebp+16]  ; porownanie x i z 
	jge		zakoncz        ; skok, gdy x >= z 
	jmp		wpisz_z 
y_wieksza: 
	mov		eax, [ebp+12]  ; liczba y 
	jmp		zakoncz 
_szukaj_max ENDP 
_szukaj4_max PROC
	push	ebp       ; zapisanie zawartoœci EBP na stosie
	mov		ebp, esp  ; kopiowanie zawartoœci ESP do EBP 
	mov		eax, [ebp+8]   ; liczba x 
	cmp		eax, [ebp+12]  ; porownanie liczb a i b 
	jge		a_wieksza      ; skok, gdy a >= b 
	; przypadek a < b 
	mov		eax, [ebp+12]  ; liczba b 
	cmp		eax, [ebp+16]  ; porownanie liczb b i c 
	jge		b_wieksza      ; skok, gdy b >= c
	mov		eax, [ebp+16]
	cmp		eax, [ebp+20]
	jge		zakoncz	   ; c >= d
	; przypadek d > c 
	; zatem d jest liczb¹ najwieksz¹
wpisz_d:
	mov		eax, [ebp+20]  ; liczba d 
zakoncz: 
	pop		ebp 
	ret 
a_wieksza: 
	cmp		eax, [ebp+16]  ; porownanie a i c 
	jge		a_w_d        ; skok, gdy a >= c 
	mov		eax, [ebp+16]
a_w_d:
	cmp		eax, [ebp+20]
	jge		zakoncz		; a >= d
	jmp		wpisz_d 
b_wieksza: 
	mov		eax, [ebp+12]  ; liczba b 
	cmp		eax, [ebp+20]
	jge		zakoncz	; b >= d
	jmp		wpisz_d
_szukaj4_max ENDP
END 