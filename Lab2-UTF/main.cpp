#include <iostream>
using namespace std;

extern "C" int find(char* str, char c, int n);

void main()
{
	char* tekst, znak;
	int n, pos;
	tekst = new char[128];

	cout << "Podaj tekst (max. 127 znakow!)" << endl;
	cin >> tekst;
	cout << "Podaj znak do wyszukania" << endl;
	cin >> znak;
	cout << "Od ktorej pozycji mam szukac?" << endl;
	cin >> n;
	
	pos = find(tekst, znak, n);
	if (pos == -1)
		cout << "Nie udalo sie znalezc znaku!" << endl;
	else
		cout << "Pozycja znaku: " << pos << endl;

	delete tekst;
}