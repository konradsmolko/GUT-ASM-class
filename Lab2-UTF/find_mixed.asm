; int find(char* str, char c, int n)
; str - wsk. do stringa
; c - szukany znak
; n - miejsce od którego szukam
; ret - miejsce na ktorym jest znak (od poczatku stringa, nie od n). brak c = ret -1
.686
.model flat
public _find_mixed
extern _strlen : PROC

.code
;mov         eax,dword ptr [n]  
;push        eax  
;movzx       ecx,byte ptr [znak]  
;push        ecx  
;mov         edx,dword ptr [tekst]
;push        edx  
_find_mixed PROC
	; push ramka stosu
	push	ebp
	mov		ebp, esp
	push	ebx
	push	edi
	push	esi
	; push koniec ramki stosu

	; wczytywanie danych
	mov		ebx, [ebp+8] ; ebx = *str
	push	ebx
	call	_strlen
	add		esp, 4
	mov		edx, [ebp+16] ; edx = n
	cmp		edx, eax ; sprawdzenie czy n nie jest wiêksze od dlugosci stringa
	jg		brak_znaku
	mov		ecx, [ebp+12] ; ecx = c
	dec		edx ; indeks od 0
	;koniec wczytywania danych

	xor		eax, eax

nastepny:
	mov		al, [ebx+edx] ; pobranie znaku
	inc		edx
	cmp		al, cl
	je		koniec
	cmp		al, 0
	jne		nastepny

brak_znaku:
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
_find_mixed ENDP
END