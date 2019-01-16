_szukaj_elem_min PROC ;int*tab, int n
	push	ebp
	mov		ebp, esp
	push	esi
	push	ebx
	
	mov		esi, [ebp+8] ;*tab
	mov		ecx, [ebp+12] ;n
	dec		ecx
	
	mov		ebx, [esi]
nastepna:
	mov		eax, [esi + ecx*4]
	cmp		ebx, eax
	cmp		eax, [esi + ecx*4]
	jle		dalej
	;znaleziono_mniejsza
	mov		ebx, eax
dalej:
	dec		ecx, 4
	cmp		ecx, 0
	je		koniec
	jmp		nastepna

koniec:
	; ecx = offset to min element + 4


	add		eax, ecx
	
	pop		ebx
	pop		esi
	mov		esp, ebp
	pop		ebp
_szukaj_elem_min ENDP