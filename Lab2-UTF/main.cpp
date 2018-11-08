//#define ASMINPUT

#ifndef ASMINPUT
	#define MAX_STR_SIZE 128
	#include <iostream>
	using namespace std;
	extern "C" int find_mixed(char* str, char c, int n);
#else
	extern "C" int find();
#endif

void main()
{
#ifndef ASMINPUT
	char* tekst, znak;
	int n, pos;
	tekst = new char[MAX_STR_SIZE];

	cout << "Podaj tekst (max. " << MAX_STR_SIZE - 1 << " znakow!)" << endl;
	cin >> tekst;
	cout << "Podaj znak do wyszukania" << endl;
	cin >> znak;
	cout << "Od ktorej pozycji mam szukac?" << endl;
	cin >> n;
	
	pos = find_mixed(tekst, znak, n);
	if (pos == -1)
		cout << "Nie udalo sie znalezc znaku!" << endl;
	else
		cout << "Pozycja znaku: " << pos << endl;

	delete tekst;
#else
	find();
#endif
}