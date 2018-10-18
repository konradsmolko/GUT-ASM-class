; program przyk�adowy (wersja 64-bitowa)
extern _write       : PROC
extern ExitProcess  : PROC

public main
.data
tekst	db 10, 'Nazywam sie Konrad Smolko' , 10
		db 'Moj pierwszy 64-bitowy program asemblerowy '
		db 'dziala juz poprawnie!', 10
.code
main PROC
	mov rcx, 1	; uchwyt urz�dzenia wyj�ciowego
	mov rdx, OFFSET tekst ; po�o�enie obszaru ze znakami
	mov r8, 92	; liczba znak�w wy�wietlanego tekstu
	sub rsp, 40	; przygotowanie obszaru na stosie dla funkcji _write
	call _write	; wywo�anie funkcji �_write� z biblioteki j�zyka C
	add rsp, 40	; usuni�cie ze stosu wcze�niej zarezerwowanego obszaru

	sub rsp, 8	; wyr�wnanie zawarto�ci RSP, tak by by�a podzielna przez 16

	mov rcx, 0	; zako�czenie wykonywania programu
	call ExitProcess	; kod powrotu programu 

main  ENDP
END