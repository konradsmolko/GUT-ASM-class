.686
.model flat
public _main
.data
	bufor dq 256 dup (12345678ABCDEF0Eh)
	wynik dq 256 dup (?)
.code
_main PROC
	pusha

	mov		esi, OFFSET bufor
	mov		edi, OFFSET wynik
	mov		ecx, 256
	xor		edx, edx

ptl1:
	mov		ebx, DWORD PTR [esi+edx*4]
	bswap	ebx
	mov		eax, DWORD PTR [esi+edx*4+4]
	bswap	eax
	mov		[esi+edx*4], eax
	mov		[esi+edx*4+4], ebx
	add		edx, 2
	cmp		edx, 256
	jl		ptl1

	xor		edx, edx
ptl2:
	mov		ebx, DWORD PTR [esi+edx*4]
	mov		eax, DWORD PTR [esi+edx*4+1]


	xor		ebx, eax
	not		ebx

	mov		[edi+edx*4], ebx
	inc		edx
	cmp		edx, 256
	;jl		ptl


	popa
_main ENDP
END