; program przykladowy (wersja 64-bitowa)
extern _write       : PROC
extern ExitProcess  : PROC

public main
.data
tekst	db 0Ah, 'Nazywam sie Konrad Smolko', 0Ah
		db 'Moj pierwszy 64-bitowy program asemblerowy '
		db 'dziala juz poprawnie!', 0Ah
.code
main PROC
	mov rcx, 1	; uchwyt urzadzenia wyjsciowego
	mov rdx, OFFSET tekst ; polozenie obszaru ze znakami
	mov r8, 93	; liczba znakow wyswietlanego tekstu
	sub rsp, 40	; przygotowanie obszaru na stosie dla funkcji _write
	call _write	; wywolanie funkcji ”_write” z biblioteki języka C
	add rsp, 40	; usuniêcie ze stosu wczesniej zarezerwowanego obszaru

	sub rsp, 8	; wyrownanie zawartosci RSP, tak by byla podzielna przez 16

	mov rcx, 0	; zakonczenie wykonywania programu
	call ExitProcess	; kod powrotu programu 

main ENDP
END