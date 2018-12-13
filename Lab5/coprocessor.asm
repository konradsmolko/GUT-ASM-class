.686
.model flat

public _nowy_exp ; float nowy_exp(float x)
;srednia kwadratowa tablicy floatow flost sr_kw(float *tab, int liczba_elem)
.data
	; 2x^2 -x -15 = 0
	wsp_a dd +2.0
	wsp_b dd -1.0
	wsp_c dd -15.0
	dwa dd 2.0
	cztery dd 4.0
	x1 dd ?
	x2 dd ?

	counter	dd ?
.code
example PROC
	finit
	fld     wsp_a		 ; załadowanie współczynnika a
	fld     wsp_b        ; załadowanie współczynnika b
	fst     st(2)        ; kopiowanie b
	; sytuacja na stosie: ST(0) = b, ST(1) = a, ST(2) = b
	fmul    st(0),st(0)  ; obliczenie b^2
	fld     cztery
	; sytuacja na stosie: ST(0) = 4.0, ST(1) = b^2, ST(2) = a,
	; ST(3) = b
	fmul    st(0), st(2) ; obliczenie 4 * a
	fmul    wsp_c        ; obliczenie 4 * a * c
	fsubp   st(1), st(0) ; obliczenie b^2 -	4 * a * c
	; sytuacja na stosie: ST(0) = b^2 -	4 * a * c, ST(1) = a,
	; ST(2) = b
	fldz                 ; zaladowanie 0
	; sytuacja na stosie: ST(0) = 0, ST(1) = b^2 - 4 * a * c,
	; ST(2) = a, ST(3) = b
	; rozkaz FCOMI - oba porównywane operandy musza być podane na
	; stosie koprocesora
	fcomi   st(0), st(1)
	; usuniecie zera z wierzchołka stosu
	fstp    st(0)       
	ja      delta_ujemna ; skok, gdy delta ujemna
	; w przykładzie nie wyodrębnia się przypadku delta = 0
	; sytuacja na stosie: ST(0) = b^2 -	4 * a * c, ST(1) = a,
	; ST(2) = b
	fxch    st(1)
	; zamiana st(0) i st(1)
	; sytuacja na stosie: ST(0) = a, ST(1) = b^2 - 4 * a * c,
	; ST(2) = b
	fadd    st(0), st(0) ; ; obliczenie 2 * a
	fstp    st(3)
	; sytuacja na stosie: ST(0) = b^2 -	4 * a * c,  ST(1) = b,
	; ST(2) = 2 * a
	fsqrt               ; pierwiastek z delty
	; przechowanie obliczonej wartości
	fst     st(3)       
	; sytuacja na stosie: ST(0) = sqrt(b^2 - 4 * a * c),
	; ST(1) = b, ST(2) = 2 * a, ST(3) = sqrt(b^2 - 4 * a * c)
	fchs                ; zmiana znaku
	fsub    st(0), st(1); obliczenie -b - sqrt(delta)
	fdiv    st(0), st(2); obliczenie x1
	fstp    x1          ; zapisanie x1 w pamięci
	; sytuacja na stosie: ST(0) = b, ST(1) = 2 * a,
	; ST(2) = sqrt(b^2 - 4 * a * c)
	fchs
	; zmiana znaku
	fadd 	st(0), st(2)
	fdiv    st(0), st(1)
	fstp    x2
	fstp    st(0)       ; oczyszczenie stosu
	fstp    st(0)
delta_ujemna:
	ret
example ENDP
_nowy_exp PROC
	push	ebp
	mov		ebp, esp
	push	ecx

	mov		ecx, 1
	finit
	fld1
	fld		dword PTR [ebp+8] ; x
	faddp	st(1),st 	; wynik poczatkowy w st(0)
	; suma = sum(n: 0->20 :: x^n / n!)
petla:
	inc		ecx
	fld		dword PTR [ebp+8] ; x
	fld		dword PTR [ebp+8] ; x
	; x^ecx
	mov		eax, ecx
potega:
	fmul	ST(1), ST(0) ; wynik w st(1)
	dec		eax
	cmp		eax, 1
	jg		potega
	fincstp
	; st(0) = x^ecx+2, st(7) = x
	; teraz potrzebna jest n!
	mov		eax, ecx
	ffree	st(7)
	fld1 ; 1#IND
silnia:
	mov		counter, eax
	fimul	counter
	dec		eax
	cmp		eax, 1 ; nie ma sensu mnożyć przez 1
	jg		silnia
	; st(2) = wynik
	; st(1) = x^n
	; st(0) = n!
	fdivp	st(1), st ; wynik w st(1), bo pop
	; teraz trzeba to dodać do wyniku
	faddp	st(1), st ; obecny wynik w st(0)

	cmp ecx, 18 ; 2 pierwsze wartości to 1 i x, obliczone przed pętlą
	jle petla

	pop		ecx
	mov		esp, ebp
	pop		ebp
	ret
_nowy_exp ENDP
END
