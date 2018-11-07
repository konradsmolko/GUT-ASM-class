; int find(char* str, char c, int n)
; str - wsk. do stringa
; c - szukany znak
; n - miejsce od którego szukam
; ret - miejsce na ktorym jest znak (od poczatku stringa, nie od n). brak c = ret -1
.686
.model flat
public _find

.code
;mov         eax,dword ptr [n]  
;push        eax  
;movzx       ecx,byte ptr [znak]  
;push        ecx  
;mov         edx,dword ptr [tekst]
;push        edx  
_find PROC
	; push ramka stosu
	push	ebp
	mov		ebp, esp
	push	ebx
	push	edi
	push	esi
	; push koniec ramki stosu
	mov		ebx, [ebp+8] ; ebx = *str
	mov		ecx, [ebp+12] ; ecx = c
	mov		edx, [ebp+16] ; edx = n (HEX)
	dec		edx ; indeks od 0
	xor		eax, eax

nastepny:
	mov		al, [ebx+edx] ; pobranie znaku
	inc		edx
	cmp		al, cl
	je		koniec
	cmp		al, 0
	jne		nastepny
	mov		edx, -1 ; doszlismy do konca stringa i brak znaku - zwracamy -1
	jmp		koniec

koniec:
	; pop ramka stosu
	pop		esi
	pop		edi
	pop		ebx
	pop		ebp
	; end koniec ramki stosu
	mov		eax, edx
	ret
_find ENDP
END