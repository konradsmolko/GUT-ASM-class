; program przyk³adowy (wersja 64-bitowa)
extern _write       : PROC
extern ExitProcess  : PROC

public main
.data
tekst	db 10, 'Nazywam sie Konrad Smolko' , 10
		db 'Moj pierwszy 64-bitowy program asemblerowy '
		db 'dziala juz poprawnie!', 10
.code
main PROC
	mov rcx, 1	; uchwyt urz¹dzenia wyjœciowego
	mov rdx, OFFSET tekst ; po³o¿enie obszaru ze znakami
	mov r8, 92	; liczba znaków wyœwietlanego tekstu
	sub rsp, 40	; przygotowanie obszaru na stosie dla funkcji _write
	call _write	; wywo³anie funkcji ”_write” z biblioteki jêzyka C
	add rsp, 40	; usuniêcie ze stosu wczeœniej zarezerwowanego obszaru

	sub rsp, 8	; wyrównanie zawartoœci RSP, tak by by³a podzielna przez 16

	mov rcx, 0	; zakoñczenie wykonywania programu
	call ExitProcess	; kod powrotu programu 

main  ENDP
END